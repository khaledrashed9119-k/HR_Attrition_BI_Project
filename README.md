# HR Employee Attrition Analysis | End-to-End BI Project

## Project Overview

An end-to-end Business Intelligence project developed as part of a technical interview case study for **Teleperformance (TP)**. The project analyzes employee attrition using SQL Server and Power BI, turning HR data into interactive dashboards and actionable insights to support workforce retention decisions.

The solution covers data preparation, relational and dimensional modeling, an SQL-based ELT workflow, DAX calculations, and business-focused reporting.

## Project Objectives

- Explore employee attrition patterns across workforce segments.
- Identify factors associated with higher attrition rates.
- Build a structured, analysis-ready data model.
- Develop interactive Power BI dashboards to answer HR business questions.
- Translate findings into practical recommendations for HR stakeholders.

## Tools & Technologies

| Tool | Purpose |
| --- | --- |
| SQL Server / T-SQL | Raw data loading, cleaning, transformations, and data warehouse preparation |
| Power BI | Data modeling, interactive dashboards, and reporting |
| DAX | KPIs and analytical measures |
| Excel / CSV | Source data preparation |
| DrawSQL | Logical schema design |

## End-to-End Workflow

### 1. Source Data Preparation

- Started with an Excel-based HR employee attrition dataset.
- Converted the source file to CSV for SQL Server ingestion.
- Reviewed the available attributes and their analytical meaning.

### 2. Logical Database Design

- Designed a logical schema to organize the data and define relationships.
- Planned the data model before implementing it in SQL Server.

### 3. Raw Data Ingestion

- Loaded the CSV source into SQL Server.
- Created a dedicated **raw schema** to preserve the ingested source data.

### 4. ELT: Transforming Data in SQL Server

- Followed **ELT (Extract, Load, Transform)**: extracted the source data, loaded it into SQL Server, then performed cleaning and transformations within SQL Server using T-SQL.
- Used T-SQL for data validation, cleaning, and preparation.
- Built an SQL-based ELT process to transform raw data into analysis-ready structures.
- Used two database schemas: **Raw** and **DWH**. This project does **not** use a separate staging schema.

### 5. Data Warehouse and Physical Model

- Implemented the prepared data structures in the DWH schema.
- Created the physical data model and configured relationships for reporting.
- Maintained the appropriate level of detail for employee-level analysis.

### 6. Power BI Reporting

- Connected Power BI to SQL Server using DirectQuery.
- Developed DAX measures for HR KPIs and attrition analysis.
- Created **two interactive dashboards** to explore the business questions and communicate results.
- Included outlier-focused analysis using two visuals.

## Business Questions

The dashboards are designed to explore questions such as:

- What is the overall employee attrition rate?
- How does attrition vary by department, job role, and other employee characteristics?
- How is attrition distributed across tenure groups?
- Which workforce segments should HR investigate more closely?
- What patterns can help inform employee retention initiatives?

These questions guide the analysis; findings should be interpreted as associations, not proof of causation.

## Dashboard Previews

Add your exported Power BI dashboard screenshots here after uploading them to the repository.

**Dashboard 1 — HR Attrition Overview**

<!-- Example: ![HR Attrition Overview](images/dashboard-1.png) -->

**Dashboard 2 — Attrition Drivers and Workforce Insights**

<!-- Example: ![Attrition Analysis](images/dashboard-2.png) -->

**Data Model**

<!-- Example: ![Physical Data Model](images/data-model.png) -->

## Key Deliverables

- SQL scripts for schema creation, data preparation, and transformations.
- Logical and physical data models.
- Power BI report with two dashboards and DAX measures.
- Project documentation and case-study presentation.
- Source or prepared dataset files, where sharing is permitted.

## Business Value

This project demonstrates how an end-to-end BI workflow can turn employee records into meaningful HR metrics, reveal attrition patterns, and support data-informed retention strategies. It also demonstrates practical skills in SQL, data warehousing, dimensional modeling, DAX, and dashboard storytelling.

## Notes

- This is a portfolio case study prepared for a technical interview, not a production Teleperformance HR system.
- The dataset and analysis should not be represented as Teleperformance's actual workforce unless independently verified.
- Dashboard images, exact KPI results, and detailed recommendations can be added once the final report assets are included in the repository.
