# Data Dictionary for Gold Layer

## Overview

The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

------------------------------------------
### 1. gold.dim_customers
* **Purpose** : Stores customer details enriched with demographic and geographic data.
* **Columns**:
  
| Column Name         | Data Type       | Description                                                                                     |
| ------------------- | ------------------- | ---------------------------------------------------------- |
| customer_key         | INT          | Surrogate kay uniquely identifying each customer record in the dimension table|
| customer_id         | INT           | Unique numerical identifier assigned to each customer                            |
| customer_number         | NVARCHAR(50)           | Alphanumeric identifier representing the customer, used for tracking and referencing.                            |
| firstname         | NVARCHAR(50)            | The customer's first name, as recorded in the system.                            |
| lastname         | NVARCHAR(50)            | The customer's last name or family name.                            |
| country         | NVARCHAR(50)            | The country of residence for the customer.                            |
| marital_status         | NVARCHAR(50)            | The marital status of the customer (e.g., 'Married', 'Single').                            |
| gender         | NVARCHAR(50)            | The gender of the customer (e.g., 'Male', 'Female', 'n/a')                            |
| birthdate         | DATE           | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-30)                            |
| create_date         | DATE           | The date and time when the customer record was created in the system                            |
