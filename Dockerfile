# Airflow base image
FROM apache/airflow:2.10.5-python3.12

# Root user for system-level installation
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y git && apt-get clean

# Switch back to airflow user
USER airflow

# Copy and install dependencies and requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy Airflow & dbt (ELT) project files
COPY --chown=airflow:root . /opt/airflow/