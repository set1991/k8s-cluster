terraform {
 backend "gcs" {
   bucket  = "bucket-tfstate-aliferenko1991"
   credentials = "/home/set/keys/new-mygcp-cred.json"
   #credentials = var.gcp_srv_key
   prefix = "kubernetes/state"
}
}
