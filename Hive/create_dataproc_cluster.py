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

from google.cloud import dataproc_v1 # type: ignore
from google.cloud.dataproc_v1.types import Cluster, ClusterConfig, InstanceGroupConfig, DiskConfig # type: ignore

# ─────────────────────────────────────────────
# ✅ CONFIG — Edit these values
# ─────────────────────────────────────────────
PROJECT_ID   = "reliable-cacao-501508-p7"
REGION       = "us-central1"           # e.g. us-central1, asia-south1
CLUSTER_NAME = "my-hive-cluster"       # must be lowercase, letters/digits/hyphens only
BUCKET_NAME  = f"{PROJECT_ID}-dataproc-temp"  # staging bucket

# ─────────────────────────────────────────────
# Cluster configuration
# ─────────────────────────────────────────────
def build_cluster_config() -> Cluster:
    return Cluster(
        project_id=PROJECT_ID,
        cluster_name=CLUSTER_NAME,
        config=ClusterConfig(
            # Master node
            master_config=InstanceGroupConfig(
                num_instances=1,
                machine_type_uri="n1-standard-2",   # 2 vCPUs, 7.5 GB RAM
                disk_config=DiskConfig(
                    boot_disk_type="pd-standard",
                    boot_disk_size_gb=50,
                ),
            ),

            # Worker nodes
            worker_config=InstanceGroupConfig(
                num_instances=2,                    # minimum 2 workers
                machine_type_uri="n1-standard-2",
                disk_config=DiskConfig(
                    boot_disk_type="pd-standard",
                    boot_disk_size_gb=50,
                ),
            ),

            # Software — enable Hive
            software_config={
                "image_version": "2.1-debian11",    # Dataproc image with Hadoop, Spark, Hive
                "optional_components": [
                    # "JUPYTER",   # uncomment to add Jupyter
                    # "ZEPPELIN",  # uncomment to add Zeppelin
                ],
                "properties": {
                    "hive:hive.metastore.warehouse.dir": f"gs://{BUCKET_NAME}/hive-warehouse/",
                },
            },
        ),
    )


def create_cluster():
    print(f"Creating Dataproc cluster: {CLUSTER_NAME}")
    print(f"   Project : {PROJECT_ID}")
    print(f"   Region  : {REGION}")
    print("-" * 50)

    # Create the Dataproc client (authenticates via ADC or service account key)
    cluster_client = dataproc_v1.ClusterControllerClient(
        client_options={"api_endpoint": f"{REGION}-dataproc.googleapis.com:443"}
    )

    cluster = build_cluster_config()

    # Submit the cluster creation request
    operation = cluster_client.create_cluster(
        request={
            "project_id": PROJECT_ID,
            "region": REGION,
            "cluster": cluster,
        }
    )

    print("Waiting for cluster to be ready (this takes ~2-5 minutes)...")

    # Wait for the long-running operation to finish
    result = operation.result()

    print("Cluster created successfully!")
    print(f"   Cluster name  : {result.cluster_name}")
    print(f"   Cluster UUID  : {result.cluster_uuid}")
    print(f"   Status        : {result.status.state.name}")


def delete_cluster():
    """Optional: call this to delete the cluster when done to save cost."""
    cluster_client = dataproc_v1.ClusterControllerClient(
        client_options={"api_endpoint": f"{REGION}-dataproc.googleapis.com:443"}
    )

    print(f"Deleting cluster: {CLUSTER_NAME}...")
    operation = cluster_client.delete_cluster(
        request={
            "project_id": PROJECT_ID,
            "region": REGION,
            "cluster_name": CLUSTER_NAME,
        }
    )
    operation.result()
    print("Cluster deleted.")


if __name__ == "__main__":
    create_cluster()
    # Uncomment to auto-delete after use:
    # delete_cluster()
