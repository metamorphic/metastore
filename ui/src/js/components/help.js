var React = require('react');
var Link = require('react-router-component').Link;

var Help = React.createClass({

  render: function () {
    return (
      <div>
        <p><i>This is alpha-ready software.</i></p>
        <p>
          Metastore captures business and technical metadata. It is used to drive transformation and loading
          processes for the Customer Experience Profile (CXP).
        </p>
        <dl className="dl-horizontal">
          <dt>Data Sources</dt>
          <dd>
            A source of data, which includes Files, Databases, and APIs.
          </dd>
          <dt>Datasets</dt>
          <dd>
            A data representation such as File or Table.
          </dd>
          <dt>Event types</dt>
          <dd>
            A type of event. Event instances are appended to the Event Log. Events are extracted from Datasets.
          </dd>
          <dt>Event property types</dt>
          <dd>
            A type of property of an event. Events are recorded with a bag of properties about the event. The
            types of properties that are recorded may be sparsely populated.
          </dd>
          <dt>Customer ID types</dt>
          <dd>
            A type of attribute, which uniquely identifies a customer.
          </dd>
          <dt>Customer ID Mapping Rules</dt>
          <dd>
            A specification of how to extract a mapping of two customer identifiers from a Dataset.
          </dd>
          <dt>Customer property types</dt>
          <dd>
            A type of property of a customer. Customer (information) states are recorded with a bag of properties
            about the customer. The types of properties that are recorded may be sparsely populated.
          </dd>
          <dt>Feature types</dt>
          <dd>
            A type of customer feature generated from the customer profile and event log, or from other features.
            Features are derived attributes that are both input to and output from analytical models.
          </dd>
          <dt>Data types</dt>
          <dd>
            A classification identifying one of various types of data as implemented by the storage technology,
            e.g. SQL data types such as NVARCHAR, INTEGER, and TIMESTAMP.
          </dd>
          <dt>Value types</dt>
          <dd>
            A classification identifying one of various types of data as used by analytical tools, e.g. the
            logical representation of an NVARCHAR Data Type may by either 'character' or 'categorical' (one
            of a finite number of labels).
          </dd>
          <dt>Security classification</dt>
          <dd>
            A classification identifying the level of control over a data item, required to meet customer,
            company or compliance obligations related to privacy, confidentiality, or protection of the
            information asset.
          </dd>
          <dt>Form schemas</dt>
          <dd>
            A specification of the information assets managed by Metastore. Metastore can be extended to manage
            new objects, attributes or relationships.
          </dd>
          <dt>Extract Metadata</dt>
          <dd>
            Analyses sample files to automatically extract metadata such as file properties including delimiter,
            header row, and data content including columns and data types.
          </dd>
          <dt>Jobs</dt>
          <dd>
            Details about transformation and load jobs that are running or have completed.
          </dd>
        </dl>
        <p>
          <strong>Pages</strong>
          <ol>
            <li><Link href="/docs/page/1">CXP Transformation and Load Procedure</Link></li>
          </ol>
        </p>
      </div>
    );
  }
});

module.exports = Help;