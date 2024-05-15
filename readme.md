# Terraform CloudRun Load Balancer Demo
The goal of this demo is to illustrate on how to deploy Next.js applications to Google Cloud Platform's (GCP) Global External Application Load Balancer as Cloud Run or App Engine application using Terraform and Docker.

## Audience
The intended audience is Software developers. 
We assume that the artifact registry is already configured and that the GCP account is able to deploy all sorts of resources.

## Dependencies
* Node.JS
* NPM
* PNPM
* GCloud CLI
* Docker
* Terraform

## Application Instructions
A Next.js application can be found in the `application` folder.

### Google Cloud Plaform Configuration
Change the current project to the target project.

`gcloud config set project <YOUR_PROJECT>`

### Docker image
Use the `Dockerfile` to build a Docker image.

`docker build --no-cache --platform linux/amd64 -t <REPOSITORY:TAG> .`

Push it to the artifact registry:
`docker push <REPOSITORY:TAG>`

### Deploy as a Cloud Run Application
`gcloud run deploy <SERVICE_NAME> --image <REPOSITORY:TAG> --region <REGION> --platform managed`

### Notes
`<REPOSITORY:TAG>` may look like `australia-southeast1-docker.pkg.dev/my-gcp-project/my-repository/my-application:latest`.

## Load Balancing Instructions
This repository divides the orchestration in two Terraform folders:

* `/load-balancer/backends`: A Terraform project that deploys a backend.
* `/load-balancer/frontends`: A Terraform project deploys frontends (HTTP,HTTPS) and the URL Map.

You may need to deploy backends first then frontends.

#### Deploying Backend
Your `terraform.tfvars` file may look like:

```terraform
project_id   = "my-gcp-project"
appengine_backends = {
  my-first-app = {
    region = "australia-southeast1"
  }
}
cloudrun_backends = {
  my-second-app = {
    region = "australia-southeast1"
  }
}


This example may result in the following infrastructure:

* Network Endpoint Groups (Serverless):
* * my-first-app-neg
* * my-second-app-neg
* Backends (HTTPS)
* * my-first-app-bs (australia-southeast1/networkEndpointGroups/my-first-app-neg)
* * my-second-app-bs (australia-southeast1/networkEndpointGroups/my-second-app-neg)

#### Deploying Frontend
Your `terraform.tfvars` file may look like:
```terraform
project_id         = "my-gcp-project"
ip_address         = "24.500.800.3"
domain             = "my-domain.com"
load_balancer_name      = "my-load-balancer"
default_service   = "my-second-app-bs"
path_rules = [
  {
    paths   = ["/first-path/*"]
    service = "my-first-app-bs"
  },
  {
    paths   = ["/second-path/*"]
    service = "my-second-app-bs"
  }
]
```

This example may result in the following infrastructure:

* URL Maps:
* * my-load-balancer-url-map (default: backendServices/my-second-app-bs)
* Target Proxies
* * my-load-balancer-http-proxy  
* * my-load-balancer-https-proxy
* SSL Certificates (Managed)
* * my-load-balancer-ssl-certificate
* * * Domain: my-domain.com
* Forwarding Rules (TCP):
* * my-load-balancer-http-forwarding-rule:
* * * IP: 24.500.800.3
* * * Target Proxy: my-load-balancer-http-proxy
* * my-load-balancer-https-forwarding-rule:
* * * IP: 24.500.800.3
* * * Target Proxy: my-load-balancer-https-proxy

### Notes about Load Balancers on GCP
On GCP, a load balancer is not a single component, rather a group of resources:

#### Backends
* Application: The actual code. Could be Google's App Engine, Cloud Functions, API Gateway, or Cloud Run service.
* Network Enpoint Group: A single endpoint within Google's network that resolves to the Application.
* Backend Service: A backend service defines how Cloud Load Balancing distributes traffic. The backend service configuration contains a set of values, such as the protocol used to connect to backends, various distribution and session settings, health checks, and timeouts.

#### Frontends
* Forwarding Rule: A forwarding rule specifies how to route network traffic to the backend services of a load balancer. A forwarding rule includes an IP address, an IP protocol, and one or more ports on which the load balancer accepts traffic.
* Target Proxy: Target proxies terminate incoming connections from clients and create new connections from the load balancer to the backends.
* SSL Certificate: An SSL certificate is a bit of code on your web server that provides security for online communications. When a web browser contacts your secured website, the SSL certificate enables an encrypted connection. If your Target Proxy works with HTTPS you may need to set SSL Certificate associated to the domain of your application.

 #### General
 * URL Map: The URL Map is where the Backends and Frontends come togheter. It also maps the website URL to different backends (hence the name).

## Documentation

https://nextjs.org/docs
