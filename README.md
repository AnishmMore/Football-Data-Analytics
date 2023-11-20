# Football-Data-Analytics

## Project Overview
This project involves a complete pipeline for extracting football data from Wikipedia, storing it in Azure Data Lake, transforming the data using Azure Databricks, querying the data through Azure Synapse, and visualizing the results in Tableau. It's designed to provide comprehensive analytics on football data for enthusiasts and analysts.

## Architecture :- End-To-End Data Engineering Project
![Stadium](https://github.com/AnishmMore/Football-Data-Analytics/blob/main/end-to-end-architecture.png)


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

## Project Components

### Extracting Data with Apache Airflow
- **File**: `wikipedia_azure.py` within the `dags` directory.
- **Description**: This is the primary DAG file containing the Apache Airflow code. 
- **Execution**:
  1. Run Airflow on localhost.
  2. Initiate the DAG to begin data extraction from Wikipedia.
  3. Data is subsequently stored in Azure Data Lake Storage Gen2.

### Data Transformation with Azure Databricks
- **File**: `Football Analytics.ipynb`.
- **Process**:
  1. Data retrieved from Azure Data Lake Storage Gen2.
  2. Transformation is executed using the Azure Databricks compute engine.
  3. Transformed data is then stored back in Azure Data Lake Storage Gen2.
- **Usage**: Execute the notebook on Azure Databricks to transform the `raw_data`.

### Querying Data with Azure Synapse
- **File**: `Synapse.sql`.
- **Functionality**: Contains a collection of SQL queries used for data analysis.
- **Utility**: Use these queries in Azure Synapse to derive insights and prepare data for visualization.

### Data Visualization in Tableau
- **File**: `Football_Analytics.twb`.
- **Tool**: Tableau is employed for creating visual representations of the data.
- **Visualization**: The dashboard within the Tableau workbook provides an interactive view of the football data.
  
![Tableau](https://github.com/AnishmMore/Football-Data-Analytics/blob/main/tableau_visualisation.png)
  
