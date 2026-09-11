# OCIPing Utility Overview

## Introduction

OCIPing is a diagnostic utility for evaluating Oracle client-to-database connectivity and SQL*Net network latency. It can help distinguish network-related response time from database processing time when an application or client experiences slow or inconsistent connections.

Estimated Time: 5 minutes

### Objectives

In this lab, you will learn:

- What the OCIPing utility measures.
- When OCIPing information is useful during a performance investigation.
- Where to obtain the utility and its documentation.
- What information is demonstrated in a typical OCIPing session.

### Prerequisites

- Access to a Linux client host with Oracle Client libraries configured.
- Network access from the client host to the target Oracle Database service.
- A valid Oracle Database connect descriptor and credentials when running the utility independently.

## About OCIPing

OCIPing performs lightweight database round trips through Oracle Call Interface connectivity. The resulting measurements provide evidence about client-to-database communication and can help identify latency, intermittent connectivity, or network-path behavior.

OCIPing is most useful when:

- An application connects successfully but database requests appear slower from one client location than another.
- Network latency is suspected between a database client and an Oracle Database service.
- A support investigation requires repeatable client-to-database round-trip measurements.
- You need to compare connectivity characteristics across hosts, routes, or database services.

OCIPing results should be reviewed with other diagnostic evidence. They do not replace database-side analysis using tools such as AWR, ASH, Performance Hub, or SQL Monitor.

## Demo Overview

The supplied demonstration shows an OCIPing environment on a Linux client host. It illustrates the utility package, the client-side working directory, and a typical terminal-based diagnostic session.

[Watch the OCIPing demonstration](files/ociping-demo.mp4)

The demonstration is provided as an overview. Commands and connection values shown in the recording are examples and must be adapted to the environment being investigated.

## Utility Access

The demonstration identifies the following command for downloading the RWP*Load Simulator 3.3.0 Linux x86-64 binary package:

```shell
<copy>
wget https://github.com/oracle/rwloadsim/releases/download/v3.3.0/generated-linux-x86_64-bin-3.3.0.tgz
</copy>
```

The release packages are available from the [Oracle RWP*Load Simulator releases page](https://github.com/oracle/rwloadsim/releases). Select the package that matches the client operating system and architecture.

## Documentation

Refer to the following sources for requirements, supported usage, and additional context:

```text
<copy>
https://support.oracle.com/epmos/faces/DocumentDisplay?id=2064368.1
</copy>
```

- [OCIPing Utility to Measure Network Latency](https://support.oracle.com/epmos/faces/DocumentDisplay?id=2064368.1) on My Oracle Support. An Oracle Support account may be required.
- [RWP*Load Simulator repository](https://github.com/oracle/rwloadsim), including the user guide in the `docs` directory.
- [RWP*Load Simulator reference manual](https://oracle.github.io/rwloadsim/refman/).

Before using OCIPing for an Oracle Support request, confirm the applicable version, platform requirements, and requested command options in the My Oracle Support document.

## Understanding the Results

Review OCIPing output for successful connections, reported round-trip measurements, variation between repeated measurements, and failures or timeouts. Compare results from the affected client with results from another client or network location when possible.

Capture the following context with the results:

| Information | Why it matters |
| --- | --- |
| Client host and operating system | Identifies the source environment and platform. |
| Oracle Client version | Helps establish compatibility and client behavior. |
| Database service and region | Identifies the target endpoint without exposing credentials. |
| Test date, time, and time zone | Correlates the results with other diagnostic data. |
| Network route or client location | Supports comparison between affected and unaffected paths. |
| OCIPing version and options | Makes the measurement reproducible. |

Do not include passwords, wallet contents, private keys, or other credentials in an evidence bundle.

You may now **proceed to the next lab**.

## Acknowledgements

- **Authors** - Shilpa Sharma, Principal User Assistance Developer
- **Contributors** - Nigel Bayliss, Product Management Architect
- **Last Updated By/Date** - Shilpa Sharma, September 2026
