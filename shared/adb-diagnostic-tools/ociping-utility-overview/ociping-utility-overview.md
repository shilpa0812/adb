# OCIPing Utility Overview

## Introduction

OCIPing is a diagnostic utility that measures the time for a lightweight Oracle Call Interface round trip over an existing database connection. It can help assess client-to-database round-trip latency when an application with frequent, short database calls experiences performance issues.

Estimated Time: 5 minutes

### Objectives

In this lab, you will learn:

- What OCIPing measures.
- When its results are useful.
- Where to download the utility and find its documentation.

### Prerequisites

- Access to a client host running an operating system supported by the selected package, with Oracle Client libraries configured.
- Network access from the client host to the target Oracle Database service.
- A valid Oracle Database connect descriptor and database credentials. Avoid putting a password directly in a command.

## About OCIPing

OCIPing repeatedly measures the time for an OCIPing call over a database connection. The results provide evidence about round-trip performance between the client and database service; they do not identify the root cause of a delay by themselves.

OCIPing is most useful when:

- An application makes many short database calls and network round-trip latency is suspected.
- You need repeatable measurements from the affected client or a comparison client.

## Demo Overview

The supplied demonstration shows an OCIPing environment on a Linux client host. It illustrates the utility package, the client-side working directory, and a typical terminal-based diagnostic session.

[Watch the OCIPing demonstration](files/ociping-demo.mp4)

The demonstration is provided as an overview. Commands and connection values shown in the recording are examples and must be adapted to the environment being investigated.

## Utility Access

Download the RWP*Load Simulator package for the client operating system and architecture from the [RWP*Load Simulator releases page](https://github.com/oracle/rwloadsim/releases). The demonstration uses a Linux client.

## Documentation

- [OCIPing documentation](https://oracle.github.io/rwloadsim/refman/ociping.html) describes usage and available options.
- [MOS Note 3008087.1: How to measure network latency for Oracle Database applications in OCI](https://support.oracle.com/support/?anchorId=&kmContentId=3008087&page=sptemplate&sptemplate=km-article) provides additional background.

## Understanding the Results

By default, OCIPing reports a round-trip time in milliseconds about once per second for 60 seconds. Each measurement is followed by the elapsed time. The summary reports the mean, standard deviation, minimum, and maximum.

- The mean is the average round-trip time.
- The standard deviation shows how much measurements varied during the run.
- The minimum and maximum show the range of measured times.

Review the output for failed connections, timeouts, or large variation. Compare repeat runs from the affected client with a comparison client when possible, using the same database service. OCIPing shows observed round-trip performance; it does not establish the cause of a delay.

Save the output and include it with an Oracle Support request when requested. Include this context:

| Information | Why it matters |
| --- | --- |
| Client host and operating system | Identifies the source environment and platform. |
| Oracle Client version | Helps establish compatibility and client behavior. |
| Database service and region | Identifies the target endpoint without exposing credentials. |
| Test date, time, and time zone | Correlates the results with other diagnostic data. |
| Network route or client location | Supports comparison between affected and unaffected paths. |
| OCIPing version and command options | Makes the measurement reproducible. |

Do not include passwords, wallet contents, private keys, or other credentials in an evidence bundle.

You may now **proceed to the next lab**.

## Acknowledgements

- **Authors** - Shilpa Sharma, Principal User Assistance Developer
- **Contributors** - Nigel Bayliss, Product Management Architect
- **Last Updated By/Date** - Shilpa Sharma, September 2026
