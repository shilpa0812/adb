# Use AWR and ADDM in Performance Hub

## Introduction

Automatic Workload Repository (AWR) stores historical performance snapshots. Automatic Database Diagnostic Monitor (ADDM) analyzes AWR data and presents findings and recommendations. In this lab, you capture a quiet AWR baseline, run a small test workload, capture a second AWR report, and use ADDM to analyze the same interval in Performance Hub.

Estimated Time: 25 minutes

### Objectives

In this lab, you will:

- Capture an AWR report before the test workload.
- Create a safe, repeatable workload that can be viewed in Performance Hub.
- Capture a second AWR report after the workload.
- Run an ADDM task for the workload interval.
- Compare the before and after AWR reports with the ADDM findings.

### Prerequisites

- You have completed the previous labs to provision an Oracle Autonomous AI Database.
- You can sign in to the OCI Console and open the Autonomous AI Database details page.
- You have access to Database Actions or SQL Worksheet to run the sample workload.
- You have permission to open Performance Hub and run an ADDM task.
- Use a non-production database. The sample table is removed during cleanup.

> **Note:** If **Run ADDM Task** or the **Reports** menu is not available, ask your database administrator to enable the required diagnostics access. Menu labels can vary by database version; choose the option labelled **AWR** or **Automatic Workload Repository**.

## AWR and ADDM in This Lab

| Tool | What it provides | How you use it here |
| --- | --- | --- |
| AWR | Historical snapshots of database activity and workload statistics. | Capture a quiet baseline report and a second report that includes the test workload. |
| ADDM | A diagnosis of AWR data, including findings, impact, and recommendations. | Analyze the after-workload interval and review the recommended next steps. |

## Task 1: Capture a Baseline AWR Report

Capture the baseline before you run the test SQL.

1. Open the OCI Console, open the Autonomous AI Database details page, and click **Performance Hub**.

2. In **Quick Select**, choose a recent time range that does not include the test workload. Confirm that the **Activity Summary** shows at least two **AWR Snapshot** markers.

3. Open the **Reports** menu and choose **Automatic Workload Repository** or **AWR**.

4. Select the earlier and later snapshot that define the quiet period, and download the report as `awr_before_workload.html`.

5. Record the report name, begin snapshot, end snapshot, and time range. These values are the baseline for comparison after the workload.

> **Note:** An AWR report compares two snapshots. If two suitable snapshots are not available, wait for another snapshot or select the most recent quiet pair before continuing.

## Task 2: Create a Test Workload

1. Open Database Actions or SQL Worksheet for a non-production schema.

2. Download and run the [AWR and ADDM workload script](files/awr-and-addm-workload.sql). The script creates a demonstration table and gathers optimizer statistics.

3. Run the tagged query in the script. The `LL_AWR_ADDM_TARGET` comment makes the statement easy to identify in Performance Hub.

    ```sql
    <copy>
    SELECT /* LL_AWR_ADDM_TARGET */
           customer_group,
           COUNT(*) AS order_count,
           ROUND(SUM(LN(order_total)), 2) AS total_work
    FROM   ll_awr_addm_orders
    JOIN   (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 50)
           multiplier ON 1 = 1
    WHERE  order_date >= TRUNC(SYSDATE) - 90
    GROUP  BY customer_group
    ORDER  BY total_work DESC;
    </copy>
    ```

    > **Note:** If the query finishes before you can view it, run it two or three times. Do not increase the workload or run it on a production database.

## Task 3: Capture an AWR Report After the Workload

1. Return to **Performance Hub** after the workload query finishes. Use **Quick Select** or a custom time range that includes the workload.

2. Review the **Activity Summary** and note the database load, CPU, User I/O, wait activity, and the time at which the workload ran.

3. Locate an **AWR Snapshot** marker after the workload. If a suitable ending snapshot is not available, wait for the next snapshot before continuing.

4. Open the **Reports** menu and choose **Automatic Workload Repository** or **AWR**.

5. Select a begin snapshot before the workload and an end snapshot after the workload. Download the report as `awr_after_workload.html`.

6. Record the report name, begin snapshot, end snapshot, and time range. Compare `awr_after_workload.html` with `awr_before_workload.html`.

Record the largest change in database load, CPU, wait class, or SQL activity between the two reports.

## Task 4: Run ADDM for the Same Activity

1. Click the **ADDM** tab and keep the same time range used for `awr_after_workload.html`.

2. Click **Run ADDM Task**.

3. Choose one option in the dialog:

    - **Capture and analyze current performance** if the workload is still running.
    - **Analyze past performance** if the workload has completed and the required AWR snapshots are available.

4. Click **Run ADDM** and wait for the task to complete. If the task is still processing, check the status message and return to the ADDM tab later.

5. Open the completed ADDM task from the result or from the AWR Snapshot marker. Review the top finding, estimated impact, recommendation, and analysis period.

Record the finding that contributed the most database time and the recommendation that ADDM provides. Treat the recommendation as a diagnostic lead and validate it before making changes.

## Task 5: Compare the Results

Use the same workload interval for both tools and complete the comparison below.

| Question | Your observation |
| --- | --- |
| What workload peak or wait class changed between the AWR reports? |  |
| Which SQL or activity was most visible after the workload? |  |
| What was the top ADDM finding and its estimated impact? |  |
| What recommendation did ADDM provide? |  |
| How did ADDM explain the change shown by AWR? |  |

AWR shows what happened during the selected interval. ADDM uses that historical evidence to explain the main performance contributors and suggest next steps.

## Task 6: Clean Up

When you finish the lab, run the [cleanup script](files/cleanup-awr-and-addm-workload.sql).

```sql
<copy>
DROP TABLE ll_awr_addm_orders PURGE;
</copy>
```

You may now **proceed to the next lab**.

## Acknowledgements

- **Authors** - Shilpa Sharma, Principal User Assistance Developer
- **Contributors** - Nigel Bayliss, Product Management Architect
- **Last Updated By/Date** - Shilpa Sharma, September 2026
