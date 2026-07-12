"""
GCP Dataproc Cluster Creator
==============================
Project   : data-engineering-project
Project ID: reliable-cacao-501508-p7

Prerequisites:
  pip install google-cloud-dataproc google-auth

Authentication (choose ONE):
  Option A: gcloud auth application-default login
  Option B: Set GOOGLE_APPLICATION_CREDENTIALS env var pointing to a service account JSON key

Usage:
  python create_dataproc_cluster.py
"""

from google.cloud import dataproc_v1  # type: ignore
from google.cloud.dataproc_v1.types import (  # type: ignore
    Cluster, ClusterConfig, InstanceGroupConfig, DiskConfig, GceClusterConfig,
)
from google.api_core.exceptions import ServiceUnavailable, AlreadyExists  # type: ignore

# ─────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────
PROJECT_ID   = "reliable-cacao-501508-p7"
CLUSTER_NAME = "hadoop-hive-cluster"
BUCKET_NAME  = f"{PROJECT_ID}-dataproc-temp"

# Machine type: e2-standard-2 is the modern replacement for n1-standard-2
#   - Same specs: 2 vCPU, 8 GB RAM
#   - Cheaper and MUCH more widely available across all regions/zones
MACHINE_TYPE = "e2-standard-2"

# Regions + zones to try IN ORDER.
# The script picks the first zone that has available capacity.
REGION_ZONES = [
    # us-central1 zones
    ("us-central1", "us-central1-b"),
    ("us-central1", "us-central1-c"),
    ("us-central1", "us-central1-f"),
    ("us-central1", "us-central1-a"),
    # us-east1 fallback zones
    ("us-east1",    "us-east1-b"),
    ("us-east1",    "us-east1-c"),
    ("us-east1",    "us-east1-d"),
    # us-west1 fallback zones
    ("us-west1",    "us-west1-a"),
    ("us-west1",    "us-west1-b"),
]

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────
def make_client(region: str) -> dataproc_v1.ClusterControllerClient:
    return dataproc_v1.ClusterControllerClient(
        client_options={"api_endpoint": f"{region}-dataproc.googleapis.com:443"}
    )


def build_cluster(region: str, zone: str) -> Cluster:
    return Cluster(
        project_id=PROJECT_ID,
        cluster_name=CLUSTER_NAME,
        config=ClusterConfig(
            gce_cluster_config=GceClusterConfig(
                zone_uri=f"projects/{PROJECT_ID}/zones/{zone}",
            ),
            master_config=InstanceGroupConfig(
                num_instances=1,
                machine_type_uri=MACHINE_TYPE,
                disk_config=DiskConfig(boot_disk_type="pd-standard", boot_disk_size_gb=50),
            ),
            worker_config=InstanceGroupConfig(
                num_instances=2,
                machine_type_uri=MACHINE_TYPE,
                disk_config=DiskConfig(boot_disk_type="pd-standard", boot_disk_size_gb=50),
            ),
            software_config={
                "image_version": "2.1-debian11",
                "optional_components": [],
                "properties": {
                    "hive:hive.metastore.warehouse.dir": f"gs://{BUCKET_NAME}/hive-warehouse/",
                },
            },
        ),
    )


def get_existing_cluster(client, region: str):
    """Return existing cluster object or None."""
    try:
        return client.get_cluster(
            request={"project_id": PROJECT_ID, "region": region, "cluster_name": CLUSTER_NAME}
        )
    except Exception:
        return None


def delete_existing_cluster(client, region: str):
    """Delete the cluster in the given region and wait for completion."""
    existing = get_existing_cluster(client, region)
    if existing is None:
        return
    state = existing.status.state.name
    print(f"   Found existing cluster in state [{state}] -> deleting it first...")
    op = client.delete_cluster(
        request={"project_id": PROJECT_ID, "region": region, "cluster_name": CLUSTER_NAME}
    )
    op.result()
    print("   Old cluster deleted.")


# ─────────────────────────────────────────────
# Main: create cluster with region/zone fallback
# ─────────────────────────────────────────────
def create_cluster():
    print(f"Creating Dataproc cluster : {CLUSTER_NAME}")
    print(f"Project                   : {PROJECT_ID}")
    print(f"Machine type              : {MACHINE_TYPE}")
    print(f"Will try {len(REGION_ZONES)} region/zone combinations until one succeeds.")
    print("-" * 60)

    last_error = None
    prev_region = None
    client = None

    for region, zone in REGION_ZONES:
        # Build a new client only when the region changes
        if region != prev_region:
            client = make_client(region)
            prev_region = region
            print(f"\n  [Region: {region}]")

        print(f"  Trying zone {zone} ...", end=" ", flush=True)

        try:
            op = client.create_cluster(
                request={"project_id": PROJECT_ID, "region": region, "cluster": build_cluster(region, zone)}
            )
            print("submitted. Waiting for cluster to be RUNNING (~2-5 min)...")
            result = op.result()

            print("\n" + "=" * 60)
            print("[OK] Cluster created successfully!")
            print(f"  Cluster name : {result.cluster_name}")
            print(f"  Cluster UUID : {result.cluster_uuid}")
            print(f"  Region/Zone  : {region} / {zone}")
            print(f"  Status       : {result.status.state.name}")
            print("=" * 60)
            return

        except AlreadyExists:
            existing = get_existing_cluster(client, region)
            if existing and existing.status.state.name == "RUNNING":
                print("\n[OK] Cluster already exists and is RUNNING — reusing it.")
                print(f"  Cluster name : {existing.cluster_name}")
                print(f"  Region/Zone  : {region} / {zone}")
                return
            else:
                state = existing.status.state.name if existing else "UNKNOWN"
                print(f"exists but in [{state}] state. Deleting...")
                delete_existing_cluster(client, region)
                continue  # retry same zone after cleanup

        except ServiceUnavailable as e:
            if "does not have enough resources" in str(e) or "UNAVAILABLE" in str(e):
                print(f"out of capacity. Trying next...")
                last_error = e
                continue
            raise  # unexpected — re-raise immediately

    print("\n[FAILED] All regions and zones are out of capacity.")
    print("Please try again later.")
    if last_error:
        raise last_error


# ─────────────────────────────────────────────
# Delete helper (call manually when done)
# ─────────────────────────────────────────────
def delete_cluster(region: str = "us-central1"):
    """Delete the cluster to stop incurring costs."""
    client = make_client(region)
    print(f"Deleting cluster: {CLUSTER_NAME} in {region}...")
    op = client.delete_cluster(
        request={"project_id": PROJECT_ID, "region": region, "cluster_name": CLUSTER_NAME}
    )
    op.result()
    print("Cluster deleted.")


if __name__ == "__main__":
    create_cluster()
    # To delete when done (pass the region the cluster was created in):
    # delete_cluster("us-central1")
