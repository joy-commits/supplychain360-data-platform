# SupplyChain360 Unified Data Platform

## Project Overview
This project delivers a fully containerized data platform that centralizes supply chain operations into a structured, analytics-ready environment. This addresses the company's challenge of data fragmentation across warehouses and stores, which previously led to stockouts, overstocking, and delivery delays.

The aim is to give the business a complete view of:
* Product stockout trends
* Supplier delivery performance
* Warehouse operational efficiency
* Regional sales demand patterns

The pipeline covers extraction from multiple sources, raw storage in Parquet format, modelling in Snowflake, orchestration, and automated deployment.

## Data Sources
| **Source** | **Description** | **Storage** |
| :--- | :--- | :--- |
| Warehouse inventory systems | Daily stock snapshots | AWS S3 (CSV files) |
| Logistics records | Shipment and delivery logs | AWS S3 (JSON files) |
| Supplier master data | Master catalog of brands | AWS S3 (CSV files) |
| Store locations | Retail store metadata | Google Sheets |
| Store sales transactions | Daily transaction tables | PostgreSQL database |

## Architecture
<img width="827" height="597" alt="supplychain360_data_platform drawio" src="https://github.com/user-attachments/assets/03987f82-6ac8-44fa-8baf-fb1572a31973" />

The platform has a modern data stack architecture:
  
1.  **Infrastructure**: Provisioned via Terraform with a remote S3 backend for state management.
2.  **Ingestion layer**: Extracts data from multiple sources:
    * **AWS S3**: Product catalogue, supplier data, and warehouse snapshots (in CSV & JSON formats).
    * **Google Sheets**: Store locations.
    * **PostgreSQL**: Daily sales transaction tables.
3.  **Raw layer**: All ingested data is converted to parquet format and stored in S3 (data lake).
4.  **Warehouse & modelling**: Data is loaded into Snowflake and modelled (using dbt) into fact and dimension tables (Star schema).
5.  **Orchestration**: Airflow coordinates the end-to-end workflow.
6.  **CI/CD**: GitHub Actions automates testing and Docker image deployment.

##  Technology Stack
| Component | Technology | Description |
| :--- | :--- | :--- |
| Cloud storage | AWS S3 | Used for the raw parquet layer (landin zone for all sources) and Terraform state |
| Infrastructure | Terraform | Manages cloud resources including S3 buckets, Snowflake objects, and IAM roles |
| Data warehouse | Snowflake | Used as the primary Data Warehouse |
| Orchestration | Apache Airflow | Manages pipelines and task dependencies |
| Transformation | dbt | Handles data cleaning, enrichment and quality checks |
| Containerization | Docker | Ensures consistent execution across environments, and packages the Airflow environment, dbt projects and scripts into a portable image |
| CI/CD | GitHub Actions | Provides CI/CD for code linting, structural testing, and image deployment |

## Setup and Installation

**Prerequisites**
* Docker Desktop
* Snowflake account
* AWS credentials

1. **Clone the repository**
   ```bash
   git clone https://github.com/joy-commits/supplychain360-data-platform.git
   cd supplychain360-data-platform
   ```

2. **Configure environment**
   ```bash
   aws configure
   ```
  Create a .env file with your credentials:
  ```bash
    AWS_ACCESS_KEY_ID=XXXX
    AWS_SECRET_ACCESS_KEY=XXXX
    SNOWFLAKE_PASSWORD=XXXX
  ```

3. **Deploy resources**
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

4. **Run with Docker**
   ```bash
   docker compose up -d
   ```

5. **Access Airflow UI**: Visit http://localhost:8081 to trigger the extract_load_transform DAG.
