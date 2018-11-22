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
