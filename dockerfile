
# start from the rocker/r-ver:3.5.0 image
FROM trestletech/plumber:latest

# install data.table
RUN R -e "install.packages('data.table')"

# copy everything from the current directory into the container
COPY / /

# open port 8000 to traffic
EXPOSE 8000

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "start_api.R"]
