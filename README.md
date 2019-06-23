## Credit scoring REST API with Docker

In this repo we aim to develop a credit scoring model in R on the Kaggle Home Credit dataset and build a production ready REST API Docker image with a credit scoring engine. The engine gest and posts JSON files as input and output. We use an EC2 AWS instance and assume that the development data is already provisioned in an S3 bucket.

Our focus is rather on how to set-up the technical infrastructure, so we do not cover the details of model development our model is just a very simple MVP which is eligible to use for the PoC of our Docker API.

## Setting up the AWS environment

Here is the step-by-step setup procedure of our stack:

 * Launch an Ubuntu Server 18.04 LTS AMI on a `t2.medium` EC2 instance, set the __S3FullAccess__ IAM role and open the outbound port 8000
 * 
 

This is a demo project of a credit risk modelling workflow and scoring API.

## Setting up the stack
### Install docker
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04#step-1-—-installing-docker

### Install Rstudio server
https://www.rstudio.com/products/rstudio/download-server/

### Set extra swapfile on the EC2 instance
https://aws.amazon.com/premiumsupport/knowledge-center/ec2-memory-swap-file/
We need the extra swap memory to compile Rcpp libraries...

### Install R packages with sudo
https://www.rplumber.io/

### Create a docker container with R inside
https://medium.com/@skyetetra/using-docker-to-deploy-an-r-plumber-api-863ccf91516d

### SFTP
Be aware that when you SFTP to the instant use the ubuntu user for file copy andafter that change the owner and the group of the file with chown and chgrp shall commands.
