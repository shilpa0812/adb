# Introduction

## **About this Workshop**

This live lab uses a small set of diagnostic tools to help you quickly characterize a performance problem, collect objective evidence, and identify where performance issues lie (SQL, wait events, CPU, I/O, or network). The goal is to start with high-level observability and then drill down, using the least intrusive tools first to collect the diagnostic data.

| Diagnostic Tool | When to Use It | What It Provides |
| --- | --- | --- |
| [**Autonomous Database Performance Hub**](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/performance-hub.html) | Characterize the performance problem and perform an initial investigation. If you can identify individual SQL statements that are long-running, download a SQL Monitor report. | Provides a centralized view of database performance, workload activity, SQL performance, waits, CPU, I/O, ASH, and ADDM recommendations. |
| [**Automatic Workload Repository (AWR) Reports**](https://docs.oracle.com/en/database/oracle/oracle-database/23/tgdba/generating-automatic-workload-repository-reports.html) | If CPU and/or I/O is busy, or database wait activity is high. Compare good vs poor performance periods, capture workload performance data, and identify top SQL consumers. | Evaluates overall database health, identifies bottlenecks, and compares workload behavior across systems and time periods. |
| [**ADDM (Automatic Database Diagnostic Monitor)**](https://docs.oracle.com/en/database/oracle/oracle-database/23/tgdba/automatic-database-diagnostic-monitor.html) | When performance issues need root-cause analysis and recommendations. | Analyzes AWR data and provides findings, impact analysis, and corrective recommendations. |
| [**Active Session History (ASH)**](https://docs.oracle.com/en/database/oracle/oracle-database/23/tgdba/analyzing-sampled-data.html) | Investigate transient performance problems and active workload behavior. | Provides detailed session-level activity history for diagnosing waits, bottlenecks, and workload patterns. |
| [**Instance Details (Middle-Tier Servers)**](https://docs.oracle.com/en/cloud/paas/oci-apm/observability-admin/view-instance-details.html) | Review performance metrics of application or middle-tier servers. | Displays CPU utilization, memory usage, and other infrastructure metrics impacting application performance. |
| [**SQL Monitor Report**](https://docs.oracle.com/en/database/oracle/oracle-database/23/tgsql/monitoring-database-operations.html) | If AWR or Performance Hub identifies a SQL statement performing poorly. | Provides detailed execution plan statistics, execution progress, waits, resource usage, and runtime behavior for a single SQL statement. |
| [**SQL Tuning Advisor**](https://docs.oracle.com/en/database/oracle/oracle-database/23/tgsql/sql-tuning-advisor.html) | If AWR or Performance Hub identifies a SQL statement performing poorly or with a suspected inefficient execution plan. | Tests alternative execution plans and recommends SQL profiles, statistics improvements, or rewrites. |
| [**SQLHC (SQL Health Check)**](https://support.oracle.com/epmos/faces/DocumentDisplay?id=1366133.1%20\(My%20Oracle%20Support\)) | If AWR or Performance Hub identifies a poorly performing SQL statement and Oracle Support assistance is required. | Collects detailed optimizer, statistics, metadata, and execution plan information for deep SQL diagnostics. |
| [**OCIPING**](https://support.oracle.com/epmos/faces/DocumentDisplay?id=2064368.*) | If network latency issues are suspected between database clients and the database. | Measures SQL\*Net/network latency and connectivity characteristics. |

Estimated Workshop Time: 3 hours

### **Objectives**

- Access monitoring views/tools in Autonomous AI Database (Database Actions/Console and performance-related views).
- Review baseline health metrics (CPU, I/O, storage, sessions, concurrency, wait events) to understand overall workload behavior.
- Identify top contributors by analyzing top SQL, high-load sessions, and expensive operations.
- Drill down with diagnostics (ASH/ADDM/AWR-style insights available in Autonomous) to pinpoint root causes.
- Capture and export evidence (performance reports, SQL details, metrics snapshots) for tuning actions or support escalation.
- Summarize findings and next steps (recommended SQL tuning, indexing, workload changes, or configuration guidance).

### **Prerequisites**

This workshop requires an Oracle Cloud account. You may use your existing account or create one in the following lab.

**<i>Note: Oracle Analytics Cloud (OAC) is not available with Oracle Cloud Free Tier (Always Free), nor is it supported in Oracle LiveLabs Sandbox hosted environments. If you run this workshop using an Always Free database or LiveLabs Sandbox environment, you can view Labs 1 and 5 on provisioning and using OAC, and later practice these steps on Oracle Autonomous AI Databases in your organization's tenancy.</i>**

Let's begin! If you need to create an account, please click **Get Started** in the **Contents** menu on the left. Otherwise, if you have an existing account, click **Lab 1: Provision Autonomous AI Database**.

### **Learn More**

* [Oracle Autonomous AI Database Serverless Documentation](https://docs.oracle.com/en/cloud/paas/autonomous-data-warehouse-cloud/index.html)

## **Acknowledgements**

- **Authors** - Shilpa Sharma, Prinicipal User Assistance Developer
- **Contributors** - Nigel Bayliss, Product Management Architect
- **Last Updated By/Date** - Shilpa Sharma, September 2026