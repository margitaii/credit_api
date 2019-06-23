## Credit scoring REST API with Docker

In this repo we aim to develop a credit scoring model in R on the Kaggle Home Credit dataset and build a production ready REST API Docker image with a credit scoring engine. The engine gest and posts JSON files as input and output. We use an EC2 AWS instance and assume that the development data is already provisioned in an S3 bucket.

Our focus is rather on how to set-up the technical infrastructure, so we do not cover the details of model development our model is just a very simple MVP which is eligible to use for the PoC of our Docker API.

In this repo you can already find the scoring model itself what we developed locally. So when we build our container we will clone this repo within the containers.

## Setting up the AWS environment

Here is the step-by-step setup procedure of our stack:

 * Launch an Ubuntu Server __16.04__ LTS AMI on a `t2.medium` EC2 instance, set the __S3FullAccess__ IAM role and open the outbound port 8000
 * SSH to the instance and install Docker as it is described here: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04#step-1-—-installing-docker
 * Add the `ubuntu` user to the `docker` group (otherwise we cannot connet to the docker service)
~~~~~~~~~~~~~~~~~~~~
$ sudo usermod -a -G docker $USER
~~~~~~~~~~~~~~~~~~~~
 * Logout from the EC2 instance and login again to make the changes effective
 * Clone this repository with the model building R sript and the dockerfile which is the recipe for our scoring engine
~~~~~~~~~~~~~~~~~~~~
$ git clone https://gitlab.com/margitai-i/credit_api.git
~~~~~~~~~~~~~~~~~~~~
 * Our task now is to build the Docker image:
~~~~~~~~~~~~~~~~~~~~
$ cd ~/credit_api
$ docker build -t credit_api .
~~~~~~~~~~~~~~~~~~~~ 

## Test the scoring engine

Now we have everything up-and-running on the instance it's time to test how does it work. We can request resources from our API in any programming environment
