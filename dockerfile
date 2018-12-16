# Stage 1
FROM rocker/r-ver:latest

RUN R -e "install.packages(c('data.table','skimr','mltools','xgboost'))"
COPY . .
RUN mkdir artifacts
RUN mkdir stage

RUN Rscript explore.R
RUN Rscript model.R

# Stage 2

FROM trestletech/plumber:latest

RUN R -e "install.packages(c('data.table','xgboost','pROC','jsonlite','png'))"

# copy artifacts from the builder
COPY . .
COPY --from=0 ./artifacts ./artifacts

# open port 8000 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "start_api.R"]
