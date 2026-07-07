project_name = data-engineering-project
project_id = reliable-cacao-501508-p7
project_number = 259452600980

Creating Dataproc cluster: my-hive-cluster
   Project : reliable-cacao-501508-p7
   Region  : us-central1
--------------------------------------------------
Waiting for cluster to be ready (this takes ~2-5 minutes)...
Cluster created successfully!
   Cluster name  : my-hive-cluster
   Cluster UUID  : 90f431d1-1aec-45c4-a98a-825e2cb758e1
   Status        : UNKNOWN
PS C:\Users\subramani.v\Documents\Subramani_PW\Hive> 

# To create a cluster some of the permissions we need to enable those are 

| API                        | Required |
| -------------------------- | -------- |
| Dataproc API               | ✅ Yes    |
| Compute Engine API         | ✅ Yes    |
| Cloud Storage API          | ✅ Yes    |
| IAM API                    | ✅ Yes    |
| Service Usage API          | ✅ Yes    |
| Cloud Resource Manager API | ✅ Yes    |

# Roles required for creating a Dataproc cluster

| Role                        | Required |
| --------------------------- | -------- |
| Dataproc Admin              | ✅ Yes    |
| Compute Instance Admin (v1) | ✅ Yes    |
| Storage Admin               | ✅ Yes    |
| Service Account User          | ✅ Yes    |
| Service Account Token Creator | ✅ Yes    |

# Step 4: Verify Compute Engine Default Service Account
IAM & Admin
→ Service Accounts

# Step 5: Give Required IAM Roles

