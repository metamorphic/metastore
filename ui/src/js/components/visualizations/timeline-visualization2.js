var React = require('react');
var vis = require('vis');
var request = require('superagent');
var Timeline = require('./timeline');
var Select = require('react-select');

var TimelineVisualization2 = React.createClass({

  getInitialState: function () {
    return {
      customerIds: [],
      customerIdSelection: null,
      customerIdTypeId: null,
      customerId: null
    }
  },

  componentDidMount: function () {
    request.get('/api/viz/customer-ids/sample?n=10')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            var ids = JSON.parse(res.text);
            var options = [];
            for (var i = 0; i < ids.length; i++) {
              var id = ids[i];
              var label = id.customer_id_type + ' | ' + id.customer_id;
              var value = id.customer_id_type_id + '|' + id.customer_id;
              options.push({label: label, value: value});
            }
            this.setState({customerIds: options});
          }
        }
      }.bind(this));
  },

  handleCustomerSelection: function (val) {
    var parts = val.split('|');
    this.setState({customerIdTypeId: parts[0], customerId: parts[1], customerIdSelection: val});
  },

  render: function () {
    return (
      <div>
        <h1>Timeline View</h1>
        <form role="form" className="form-horizontal">
          <div className="form-group">
            <label htmlFor="customerId" className="col-sm-2 control-label">Customer ID</label>
            <div className="col-sm-4">
              <Select name="customerId" value={this.state.customerIdSelection} options={this.state.customerIds} onChange={this.handleCustomerSelection}/>
              <span id="helpBlock" className="help-block">Selects 10 random customers</span>
            </div>
          </div>
        </form>
        <Timeline customerIdTypeId={this.state.customerIdTypeId} customerId={this.state.customerId}/>
      </div>
    );
  }
});

module.exports = TimelineVisualization2;