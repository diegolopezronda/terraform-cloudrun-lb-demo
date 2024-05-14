#!/bin/sh
# These are the resources related to load balancers.
gcloud compute network-endpoint-groups list; 
gcloud compute backend-services list; 
gcloud compute url-maps list; 
gcloud compute ssl-certificates list; 
gcloud compute target-http-proxies list; 
gcloud compute target-https-proxies list; 
gcloud compute forwarding-rules list; 