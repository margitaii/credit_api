## Credit scoring REST API with Docker

In this repo we aim to develop a credit scoring model in R on the Kaggle Home Credit dataset and build a production ready REST API Docker image with a credit scoring engine. The engine gest and posts JSON files as input and output. We use an EC2 AWS instance and assume that the development data is already provisioned in an S3 bucket.

Our focus is rather on how to set-up the technical infrastructure, so we do not cover the details of model development our model is just a very simple MVP which is eligible to use for the PoC of our Docker API.

In this repo you can already find the scoring model itself what we developed locally. So when we build our container we will clone this repo within the containers.

## Setting up the AWS environment

Here is the step-by-step setup procedure of our stack:

 * Launch an Ubuntu Server __16.04__ LTS AMI on a `t2.medium` EC2 instance, set the __S3FullAccess__ IAM role and open the inbound port 8000
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
 * Our task now is to build the Docker image (this will take for a while on a new instance (~20 mins):
~~~~~~~~~~~~~~~~~~~~
$ cd ~/credit_api
$ docker build -t credit_api .
~~~~~~~~~~~~~~~~~~~~
 * When we have our container ready, we start it:
~~~~~~~~~~~~~~~~~~~
$ docker run --name mycredit_api -p 8000:8000 credit_api 
~~~~~~~~~~~~~~~~~~~

## Test the scoring engine

Now we have everything up-and-running on the instance, it's time to test how does it work. We can request resources from our API in any programming environment. For example execute the `test_container.R` script from your local laptop (make sure you update the Public DNS of the EC2 instance in the script AND have the `httr`, `magrittr` and `jsonlite` packages installed).

The engine is a REST API built with R `plumber` package and it can return different media formats (plots, JSON files, etc.). In the `test_container.R` (see this file in this current repo) file we provide two examples:

 * The `rsp1` data frame will give you back the feature importance of our model
 * The `rsp2` data frame provides the example of a scored sample of 100 clients.

 
