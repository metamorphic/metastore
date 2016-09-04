# CXP Transformation and Load Procedure

If we examine a typical ETL process, data is extracted from one or more
sources, such as a file or database, transformed (filtered, joined,
lookup values for inclusion, etc.), and then loaded into a target file
or database.

The CXP process is concerned with the transformation and load steps. It
is expected that source data has already been extracted from sources and
landed as a file on a shared file system – HDFS or NFS (the ‘Data
Lake’).

Therefore, this process will typically extract data from files
containing a superset of information, instead of performing queries to
extract the subset of data required for the use case.

Secondly, an ETL process using customer data may resolve a customer
identifier to a common or ‘golden’ key by querying a data source for
mapping information, and then joining with the dataset.

It is expected that id mapping information will be extracted and loaded
onto a system as a separate process so that mapping rules can be applied
as a common service. The CXP process will use this common service to
link customer records to a unique customer instead of performing queries
to extract mapping information on a per use case basis.

Thirdly, there is an opportunity to link events as output by this
process as a post processing step instead of within the procedure for a
specific use case.

This document outlines a ‘fast route’ for loading datasets into the
event log data structures.

Finally, it is expected that while some users will access the event log
directly (or via a view that removes control data and substitutes type
ids with names), other users will prefer a different perspective that
pivots and summarises event data into customer features. This is
currently out of scope of the current stage. Also, there are currently
other stores of customer feature data. However, it is my opinion that a
shared feature store using the full power of a big data platform to
refresh features and generate new ones in an operational and supported
environment, which can feed online and real-time systems, will be a key
enabler of competitive advantage.

## Fast route to loading a dataset into the CXP

1.  Extract and refine metadata about the dataset.

    a) Prepare a sample file of the dataset, around 200K file size or
    200 lines of data should be sufficient – enough data to profile
    to determine whether a column contains text, times, numeric data
    etc.
    
    b) The ‘Extract Metadata’ function of the Metastore enables the
    sample file to be dropped onto the page for analysis. The result
    is a populated Dataset, its Data Source, and the list of Columns
    in the Dataset with associated technical metadata that can be
    derived from profiling the sample file.
    
    ![](/assets/extract_metadata.png)

1.  Check the metadata by reviewing the definitions of the new Dataset,
Data Source, and Columns. For example, does it have the correct data
type?

    ![](/assets/file_columns.png)![](/assets/dataset_definition.png)

1.  Define the Event Types that can be extracted from the Dataset and
mapping rules for populating event attributes from the dataset
columns. There are four mapping expressions that must be populated:

    - **Filter Expression** – determines whether to include a row for this
    event
    
    - **Customer ID Expression** – how to map one or more columns to the
    customer ID
    
    - **Value Expression** – how to map one or more columns to the event
    value. The value of an event is specific to the event type, and in
    some cases may simply be the name of the event type.
    
    - **Timestamp Expression** – how to map one or more columns to the
    event timestamp.
    
    The expression syntax uses [Spring Expression Language](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/expressions.html).
    The expression language is more powerful than the expression syntax
    used in many ETL tools, and includes:
    
    - Literal values
    
    - Boolean and relational operators
    
    - Regular expressions
    
    - User-defined functions
    
    The keyword ‘\#this’ is used to refer to the current row of data being
    processed. Column values can be accessed by using the following
    notation, <code>\#this[‘&lt;Column name&gt;’]</code>, for example,
    <code>\#this[‘Agent’]</code>.
    
    ![](/assets/event_types.png) ![](/assets/event_mapping.png)
    
    (Please note, a current limitation is that only one type of Customer ID
    can be mapped for a given event type. This will be enhanced to support
    multiple possible Customer ID Types, for example, to use a fallback ID
    if the primary ID does not have data.)

1.  Link the Dataset to one or more Event Types. This is done in the
edit form from the Datasets grid.

1.  Define the Event Property Types that should be captured along with
the event. In many cases, this may be a one-to-one mapping to a
column. From the list of columns (accessed from the Datasets
function), there is an action to ‘Make Property Type’ from a given
Column. This will create an Event Property Type of the same name and
populate the mapping rule. Alternatively, Event Property Types can
be manually created with a mapping expression that will populate the
property value from one or more columns. Property Types created in
this way must be linked to the column from which it is derived,
which can be done from the edit form from the Columns grid.

    (Please note, a current limitation is that an Event Property Type can be
    linked to only one Column. This will be enhanced to support multiple
    possible Columns. You can in fact map more than one column to a Property
    Type in the mapping expression, but the Property Type can be linked to
    only one column. It doesn’t matter which of the columns is used, but
    must be one and only one. This is a limitation in the UI, not the
    underlying data model.)

1.  Ensure the Customer ID Type used in the Dataset is in the list of
Customer ID Types. Link the correct Customer ID Type to the Event
Type. This is done in the edit form from the Event types grid.

The configuration is now done to start using for transformation and
loading.

TODO procedure for setting up and running ingest using Spring-XD.