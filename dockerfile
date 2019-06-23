# Stage 1 - Offline development
# In the first stage we estimate and create the model object and
# save it in the artifacts directory
FROM rocker/r-ver:latest

RUN R -e "install.packages(c('data.table','skimr','mltools','xgboost','rmarkdown'))"
COPY . .
RUN mkdir stage
	&& mkdir data \
	&& apt-get update \
	&& apt-get install -y awscli
# Copy the data from S3
RUN aws s3 sync s3://creditapi ./data

# Run EAD report
RUN R -e "library(rmarkdown); rmarkdown::render('explore.Rmd', output_dir = 'artifacts')"

# Data preparation
RUN Rscript prep_data.R

# Run model and save it as an R object in the artifacts folder
RUN Rscript model.R

# Stage 2 - Online production
# Here we build the REST API for the scoring engine as start at port 8000
FROM trestletech/plumber:latest

RUN R -e "install.packages(c('data.table','xgboost','pROC','jsonlite','png'))"

# copy artifacts from the builder
COPY . .
COPY --from=0 ./artifacts ./artifacts

# open port 8000 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "start_api.R"]
