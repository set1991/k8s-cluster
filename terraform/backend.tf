terraform {
 backend "gcs" {
   bucket  = "bucket-tfstate-aliferenko91"
   credentials = "/home/set/keys/mygcp-cred.json"
   #credentials = var.gcp_srv_key
   prefix = "kubernetes/state"
}
}