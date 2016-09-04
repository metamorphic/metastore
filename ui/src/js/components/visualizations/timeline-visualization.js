var React = require('react');
var vis = require('vis');
var request = require('superagent');
var Timeline = require('./timeline');
var Select = require('react-select');

var TimelineVisualization = React.createClass({

  getInitialState: function () {
    return {
      customerIdTypes: [],
      customerIds: [],
      customerIdTypeId: null,
      customerId: null
    }
  },

  componentDidMount: function () {
    request.get('/api/viz/customer-id-types')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            this.setState({customerIdTypes: JSON.parse(res.text)});
          }
        }
      }.bind(this));
    $(this.refs.minInteractions.getDOMNode()).on('changed.fu.spinbox', function () {
      if (this.state.customerIdTypeId) {
        this.handleTypeSelection(this.state.customerIdTypeId);
      }
    }.bind(this));
  },

  handleTypeSelection: function (val) {
    var minInteractions = $(this.refs.minInteractions.getDOMNode()).spinbox('value') || 5;
    request.get('/api/viz/customer-id-types/' + val + '/sample?n=10&min-interactions=' + minInteractions)
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            var customerIds = JSON.parse(res.text);
            var options = [];
            for (var i = 0; i < customerIds.length; i++) {
              options.push({label: customerIds[i], value: customerIds[i]});
            }
            this.setState({customerIds: options, customerIdTypeId: val});
          }
        }
      }.bind(this));
  },

  handleCustomerSelection: function (val) {
    this.setState({customerId: val});
  },

  render: function () {
    return (
      <div>
        <h1>Timeline View</h1>
        <form role="form" className="form-horizontal">
          <div className="form-group">
            <label htmlFor="customerIdTypeId" className="col-sm-2 control-label">Customer ID Type</label>
            <div className="col-sm-4">
              <Select id="customerIdTypeId" name="customerIdTypeId" value={this.state.customerIdTypeId} options={this.state.customerIdTypes} onChange={this.handleTypeSelection}/>
            </div>
          </div>
          <div className="form-group">
            <label htmlFor="minInteractions" className="col-sm-2 control-label">Min interactions</label>
            <div className="col-sm-4">
              <div className="spinbox" data-initialize="spinbox" ref="minInteractions">
                <input id="minInteractions" name="minInteractions" type="text" className="form-control input-mini spinbox-input" defaultValue="5"/>
                <div className="spinbox-buttons btn-group btn-group-vertical">
                  <button type="button" className="btn btn-default spinbox-up btn-xs">
                    <span className="glyphicon glyphicon-chevron-up"></span><span className="sr-only">Increase</span>
                  </button>
                  <button type="button" className="btn btn-default spinbox-down btn-xs">
                    <span className="glyphicon glyphicon-chevron-down"></span><span className="sr-only">Decrease</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="form-group">
            <label htmlFor="customerId" className="col-sm-2 control-label">Customer ID</label>
            <div className="col-sm-4">
              <Select name="customerId" value={this.state.customerId} options={this.state.customerIds} onChange={this.handleCustomerSelection}/>
              <span id="helpBlock" className="help-block">Selects 10 random customers</span>
            </div>
          </div>
        </form>
        <Timeline customerIdTypeId={this.state.customerIdTypeId} customerId={this.state.customerId}/>
      </div>
    );
  }
});

module.exports = TimelineVisualization;