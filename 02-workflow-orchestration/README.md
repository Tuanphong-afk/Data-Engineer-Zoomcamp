# Module 2: Workflow Orchestration with Kestra

This folder contains my work for Module 2 of the Data Engineering Zoomcamp. In this module, I focused on learning how to orchestrate data workflows using **Kestra**, moving from simple scripts to fully automated ETL pipelines.

## 1. Introduction

In this module, I learned how to build and manage reliable data pipelines. The core technologies and concepts I practiced include:

* **Docker Compose Configuration:** I customized the `docker-compose.yml` file to build a comprehensive, containerized infrastructure. Instead of running services in isolation, I integrated **Postgres** (serving as the Data Warehouse) and **PGAdmin** directly alongside the **Kestra** platform. This setup ensures a fully reproducible environment where the orchestrator, database, and management UI launch together with a single command.
* [cite_start]**Workflow Orchestration:** Using **Kestra** to orchestrate the entire ETL process (Extract, Transform, Load)[cite: 536, 537].
* [cite_start]**Infrastructure as Code:** Running the entire data stack (Kestra, Postgres, PGAdmin) locally using **Docker Compose**[cite: 508, 510].
* [cite_start]**ETL Pipeline:** Building flows to extract data from CSV files (NYC Taxi dataset), process it, and load it into a Postgres Data Warehouse[cite: 528].
* [cite_start]**Scheduling & Backfilling:** Configuring Schedule triggers to automate daily runs and using the **Backfill** feature to process historical data (e.g., the entire year of 2020) without manual intervention[cite: 530, 531].
* [cite_start]**Postgres & SQL:** Querying and managing data within a Postgres database running in a Docker container[cite: 511].

## 2. Homeworh.

### Question 1: Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?

* **Answer:** 128.3 MB
* **Explanation:** I executed the `05_postgres_taxi_scheduled` flow with the inputs: `taxi: yellow`, `year: 2020`, `month: 12`. **Crucially**, I disabled the `purge_files` task (type: `io.kestra.plugin.core.storage.PurgeCurrentExecutionFiles`) before execution to prevent Kestra from automatically deleting intermediate files. After the run completed, I navigated to the **Outputs** tab of the execution, expanded the `extract` task outputs, and verified the file size of `yellow_tripdata_2020-12.csv`.

### Question 2: What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?

* **Answer:** `green_tripdata_2020-04.csv`

### Question 3: How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?

* **Answer:** `24,648,499`
* **Explanation:** I used the **Backfill** feature in Kestra to execute the ETL pipeline for the entire year of 2020 (inputs range from `2020-01-01` to `2020-12-31`). After the backfill process successfully loaded all 12 months of data into the database, I ran the following SQL query in PGAdmin to verify the total row count:
  ```sql
  SELECT count(1) 
  FROM public.yellow_tripdata 
  WHERE filename LIKE '%2020%';

### Question 4: How many rows are there for the Green Taxi data for all CSV files in the year 2020?

* **Answer:** `1,734,051`
* **Explanation:** I created a new flow `02_postgres_green_taxi` adapted from the Yellow Taxi example. I used the **Backfill** feature to process the data for the entire year of 2020 (`2020-01-01` to `2020-12-31`). Once the data was loaded into Postgres, I ran the following query in PGAdmin:
  ```sql
  SELECT count(1) 
  FROM public.green_tripdata 
  WHERE filename LIKE '%2020%';
  
### Question 5: How many rows are there for the Yellow Taxi data for the March 2021 CSV file?

* **Answer:** `1,925,152`
* **Explanation:** I executed the `02_postgres_taxi` flow with the inputs `taxi: yellow`, `year: 2021`, `month: 03`. After the pipeline successfully extracted and loaded the data into the Postgres database, I verified the row count by running the following SQL query in PGAdmin:
  ```sql
  SELECT count(1) 
  FROM public.yellow_tripdata 
  WHERE filename LIKE '%2021-03%';
  
### Question 6: How would you configure the timezone to New York in a Schedule trigger?

* **Answer:** Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration.
* **Explanation:** Kestra relies on the IANA Time Zone Database standard to handle timezones and Daylight Saving Time (DST) transitions correctly. Therefore, the canonical ID `America/New_York` is used instead of fixed offsets (like UTC-5) or abbreviations (like EST).
* **Note:** The `timezone` property must be defined specifically inside the `triggers` section of the flow (under the `io.kestra.plugin.core.trigger.Schedule` type), not at the global flow level.






