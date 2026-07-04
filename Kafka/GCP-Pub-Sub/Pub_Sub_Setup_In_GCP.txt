Python Package For Installation
-------------------------------

pip3 install google-cloud-pubsub




Steps to be followed for GCP Pub-Sub
-------------------------------------
1.) Make sure Google cloud sdk is installed to access gcloud cli commands
2.) Create Pub-Sub topics named as orders_data with default subscribers
3.) Before publishing/consuming data in pub-sub topic, make sure gcp account is authenticated from terminal
4.) Use this command to authenticate "gcloud auth application-default login", it will take you to new browser window there you need to select registered email id for gcp account
5.) Open IAM & Admin service, add pub-sub publisher and pub-sub subscriber role for the email_id which is being used in GCP


