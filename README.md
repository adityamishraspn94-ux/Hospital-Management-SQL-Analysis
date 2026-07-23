# Hospital Management System: SQL Data Analysis

## 1. Project Overview
This project is an end-to-end SQL data analysis project based on a simulated **Hospital Management System** database. The primary objective is to use core SQL queries to analyze operational tables—patients, doctors, appointments, treatments, and billing—to extract actionable business insights regarding hospital efficiency, patient demographics, staff workload, and financial performance.

---

## 2. Scope of Analysis
The analysis covers four core operational areas using standard SQL operations (Joins, Aggregations, Grouping, Filtering, and Conditional Logic):
* **Patient Demographics & Acquisition:** Tracking total patient volumes, recent registration trends (past 30 days), geographic address distributions, age group segmentations, and email domain usage.
* **Workforce & Doctor Performance:** Evaluating total doctor headcounts, specializations, experience levels (senior vs. junior categorization), and appointment workloads.
* **Clinical Operations:** Analyzing appointment status distribution (completed, cancelled, no-show), recent appointment flows (past 7 days), and medical treatment cost metrics (min, max, average).
* **Financial Performance:** Measuring total paid revenue generation, payment status breakdowns, and identifying top-spending (VIP) patients.

---

## 3. Key Business Insights
* **Low Patient Acquisition Warning:** Tracking recent registrations revealed only one new patient in the last 30 days, indicating a very low acquisition rate that requires administrative attention or marketing adjustments.
* **Localized Patient Clusters:** Grouping patients by their addresses highlighted specific high-density residential zones, pointing to localized demand and strong referral networks for targeted health campaigns.
* **Doctor Workload Imbalance:** Joining doctor records with appointment volumes successfully identified heavily booked specialists versus underutilized staff members.
* **Revenue Transparency & VIP Identification:** Financial queries mapped total paid revenue cash inflows and isolated top-contributing patients, establishing a baseline for premium healthcare services or loyalty programs.

---

## 4. Technologies Used
* **Database:** MySQL Workbench
* **Techniques:** `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `JOIN` (Inner & Left), `AGGREGATE FUNCTIONS` (SUM, AVG, COUNT, MIN, MAX), `CASE WHEN`, `TIMESTAMPDIFF`.
