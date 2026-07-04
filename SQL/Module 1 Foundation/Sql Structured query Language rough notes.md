**Sql Structured query Language.**

Database : it is refers to a software that are used to store and retrive data in organized way.
    two types :
        1. RDBMS : Relational Database Management System
            stores data in tabular format : rows and columns
            uses SQL to manage data
            examples: MySQL, PostgreSQL, Oracle, SQL Server
        2. NoSQL : Not Only SQL
            stores data in various formats : documents, key-value pairs, graphs, wide-column
            uses various query languages
            examples: MongoDB, Cassandra, Redis, Firebase

## What is Database Management System? 
    It is software used to create and manage databases.
    it allows users to interact with the data

## Components of DBMS
    1. Data Storage : it is the physical storage of data in the database.
    2. Data Schema : it is the logical structure of the database.
    3. Database Engine : it is the core of the DBMS that handles data storage and retrieval.
    4. Query Processor  : it is the component that processes queries and returns results.
    5. Security and Authorization : it is the component that handles security and authorization.
    6. Query Optimizer  : it is the component that optimizes queries and returns results.

## Types of Databases:
   1. Relational Databases : 
        They are MySQL, Oracle, PostgreSQL, SQL Server.
        They use SQL to manage data.
        relationship and referential integrity.
        structured data
        sql support
        transactions and ACID properties
        Indexing and Optimization
        Security Features
   2. Time-series Databases : 
        They are InfluxDB, TimescaleDB, Prometheus, Graphite.
        High write and read operations and query perfomrance 
        data compression : Process of reducing the size of digital file or data Streams by encoding information with fewer bits than original representation.
            Types:
                Lossless compression: Data can be restored to its original form exactly as it was before compression. 
                Lossy compression: Some amount of information is lost during compression. 
        time based data
        built-in time series functions
        scalability
        IoT, monitoring, financial data
   3. NoSQL Databases : 
        They are MongoDB, Cassandra, Redis, Firebase.
        They use various query languages to manage data.
        flexible 
        document based
        column-based
        key-value
        Graph-Database
        Distributed Architecture
        Concurrency control
        Sql Compatibility
        Horizontal Scaling
        Cost Effective
        High Availability
        

## What is Relational Database? 
    It is a type of database that stores data in a tabular format with rows and columns.

## SQL vs NOSQL:
    SQL : 
        Structured data
        Relational databases
        ACID compliance
        Examples: MySQL, Oracle, PostgreSQL, SQL Server
    NoSQL : 
        Unstructured data
        Non-relational databases
        BASE compliance
        Examples: MongoDB, Cassandra, Redis, Firebase

## Transaction in DBMS
    In sql, transaction refers to a sequence of operations that are performed as a single unit of work.

## State of Transaction
    1. Active : The transaction is being executed.
    2. Partial commit : The transaction is being executed and the data is being written to the database.
    3. Commit : The transaction is completed successfully and the data is written to the database.
    4. Failed : The transaction is failed and the data is not written to the database.
    5. Abort : The transaction is aborted and the data is not written to the database.

## ACID Properties:
    1. Atomicity : It is the property that ensures that all the transactions are completed successfully or none of the transactions are completed.
    2. Consistency : It is the property that ensures that the database is in a consistent state after the transaction.
    3. Isolation : It is the property that ensures that the transactions are independent of each other.
    4. Durability : It is the property that ensures that the transactions are durable and the data is not lost in case of system failure.

## BASE Properties:
    1. Basically Available
    2. Soft state
    3. Eventual consistency
