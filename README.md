# Water-Quality-DW-on-SQL-Server
This is an MSSQL Data Warehouse and ETL implementation on specially formatted Water Quality dataset from DEFRA, UK. It is a personal academic-grade exercise to explore the basic concepts of data warehousing and manual ETL process from an academic perspective.


## Introduction:
A data warehouse is a central repository of information that can be analyzed to make more informed decisions. Data flows into a data warehouse from transactional systems, relational databases, and other sources, typically on a regular cadence (https://aws.amazon.com/what-is/data-warehouse).

This repository is about a data warehouse project that was carried out using manually triggered ETL (extract, transform, and load) process on a [specially formatted WaterQuality dataset](https://github.com/vaxdata22/Water-Quality-DW-on-SQL-Server/blob/main/WaterQuality.accdb) from The Department for Environment Food & Rural Affairs (DEFRA), UK. This particular dataset is provided in an MS Access (.accdb) file. It contains 17 tables, and each would have to be exported into individual CSV files.

The data warehouse consists of a staging table, nine (9) dimension tables, and one fact table. Among the dimension tables is an extended Time table to aid time-based BI analysis. The data warehouse was created in a Microsoft SQL Server 2019 database environment with the source dataset exported into CSV files, and then imported into corresponding tables in the database using SQL Server Management Studio (SSMS) Import wizard; while the main ETL process was done in a Jupyter Notebook (Python environment) which was connected to the data warehouse in the MSSQL database through the `pyodbc` Python cursor connection.

Finally, SQL queries were run on the data warehouse star schema using the project questions to gain insights into the data.

## Objectives of the project:

These are the objectives of the project:

* To design a data warehouse on Microsoft SQL Server database environment for the WaterQuality dataset to enable analysis.
* To implement ETL process and demonstrate its use cases especially in the transform and load phases.
* To demonstrate the use of Python environment to interact with the data warehouse.

The following are information desired to be gotten from the dataset:

1. The list of water sensors measured by type of sensor by month
2. The number of sensor measurements collected by type of sensor by week
3. The number of measurements made by location by month
4. The average number of measurements covered for pH by year
5. The average value of Nitrate measurements by locations by year

## Deliverables on the project:

* Here is the [Jupyter Notebook](https://github.com/vaxdata22/Water-Quality-DW-on-SQL-Server/blob/main/Python%20Environment%20To%20Demonstrate%20DW%20%26%20ETL%20on%20MSSQL.ipynb) for the Python environment that was used to carry out data cleaning, and ETL
* For reference purposes, here are all the [T-SQL scripts and codes](https://github.com/vaxdata22/Water-Quality-DW-on-SQL-Server/tree/main/T-SQL%20scripts) that were used throughout the project.

## PS

* For code comparison sake, here is the [Oracle SQL equivalent](https://github.com/vaxdata22/Water-Quality-DW-on-SQL-Server/blob/main/Corresponding%20Code%20To%20Illustrate%20ETL%20on%20Oracle%20DW.ipynb) of the Jupyter Notebook mentioned above.
* If you need to see exactly how I implemented it in Oracle DW, see [this](https://github.com/vaxdata22/Water-Quality-DW-on-Oracle-Database) repository.

Enjoy!
