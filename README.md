# Football-Data-Analytics

## Project Overview
This project involves a complete pipeline for extracting football data from Wikipedia, storing it in Azure Data Lake, transforming the data using Azure Databricks, querying the data through Azure Synapse, and visualizing the results in Tableau. It's designed to provide comprehensive analytics on football data for enthusiasts and analysts.

## Architecture :- End-To-End Data Engineering Project


## Prerequisites
- Apache Airflow
- Azure Data Lake Storage Gen2 account
- Azure Databricks workspace
- Azure Synapse Analytics workspace
- Tableau Desktop or Tableau Public account

## Installation and Setup
1. Clone the Repository: git clone https://github.com/AnishmMore/Football-Data-Analytics.git
2. Azure Setup:
    - Set up Azure Data Lake Storage Gen2.
    - Configure Azure Databricks workspace.
    - Initialize Azure Synapse Analytics workspace.
3. Airflow Setup: Detail how to set up Apache Airflow to run your DAGs.

## Usage
Extracting Data with Apache Airflow
  Inside dags is the wikipedia_azure.py which is the main DAG file that has the code for airflow, after running airflow on localhost, start the dag then the data is extracted from wikipedia and then stored in azure data lake v2.

Data Transformation with Azure Databricks
  Data is retreived from azure data lake v2 and azure databricks compute engine is used to transform the data which is wrriten in Football Analytics.ipynb you can run the same code on azure databricks to transform the raw_data and store in datalake v2.

Querying Data with Azure Synapse
  Synapse.sql consists of all queries that i have worked on to further work on visualisation. Synapse is used to better understand the data.

Data Visualization in Tableau
  Tableau is used for visualisation. 
  
  
