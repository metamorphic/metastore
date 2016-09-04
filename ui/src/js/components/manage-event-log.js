var React = require('react');
var MetaformActions = require('metaform').AppActions;
var LaddaButton = require('react-ladda');
var request = require('superagent');

var ManageEventLog = React.createClass({

  getInitialState: function () {
    return {
      mergeEventTypesBtnActive: false,
      mergeCustomerIdTypesBtnActive: false,
      mergeJobsBtnActive: false,
      reindexBtnActive: false
    };
  },

  mergeEventTypes: function () {
    this.setState({mergeEventTypesBtnActive: true});
    request.put('/api/event-types/merge')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({mergeEventTypesBtnActive: false});
      }.bind(this));
  },

  mergeCustomerIdTypes: function () {
    this.setState({mergeCustomerIdTypesBtnActive: true});
    request.put('/api/customer-id-types/merge')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({mergeCustomerIdTypesBtnActive: false});
      }.bind(this));
  },

  mergeJobs: function () {
    this.setState({mergeJobsBtnActive: true});
    request.put('/api/jobs/merge')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({mergeJobsBtnActive: false});
      }.bind(this));
  },

  reindex: function () {
    this.setState({reindexBtnActive: true});
    request.put('/api/entities/reindex')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({reindexBtnActive: false});
      }.bind(this));
  },

  render: function () {
    return (
      <div className="dashboard-actions">
        <h1>Manage Event Log</h1>
        <br/>
        <div className="row">
          <div className="col-md-3 col-md-offset-1 text-center">
            <LaddaButton style="contract" active={this.state.mergeEventTypesBtnActive}>
              <button type="button" className="btn btn-default btn-lg"
                      onClick={this.mergeEventTypes}>Merge Event Types</button>
            </LaddaButton>
            <LaddaButton style="contract" active={this.state.mergeCustomerIdTypesBtnActive}>
              <button type="button" className="btn btn-default btn-lg"
                      onClick={this.mergeCustomerIdTypes}>Merge Customer ID Types</button>
            </LaddaButton>
            <LaddaButton style="contract" active={this.state.mergeJobsBtnActive}>
              <button type="button" className="btn btn-default btn-lg"
                      onClick={this.mergeJobs}>Merge Jobs</button>
            </LaddaButton>
            <LaddaButton style="contract" active={this.state.reindexBtnActive}>
              <button type="button" className="btn btn-default btn-lg"
                      onClick={this.reindex}>Reindex Search Index</button>
            </LaddaButton>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = ManageEventLog;