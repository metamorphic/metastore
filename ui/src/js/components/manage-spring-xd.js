var React = require('react');
var request = require('superagent');
var MetaformActions = require('metaform').AppActions;
var AddXdJobForm = require('./add-xd-job-form');
var StoreWatchMixin = require('../mixins/store-watch-mixin');
var AppStore = require('../stores/app-store');
var AppActions = require('../actions/app-actions');
var LaddaButton = require('react-ladda');

function getStreamNamespaces() {
  return {namespaces: AppStore.getStreamNamespaces()};
}

var ManageSpringXd = React.createClass({

  mixins: [StoreWatchMixin(getStreamNamespaces)],

  getInitialState: function () {
    return {
      redeployBtnActive: false,
      redeployNamespaceBtnActive: false,
      removeBtnActive: false,
      undeployNamespaceBtnActive: false
    };
  },

  componentDidMount: function () {
    AppActions.getStreamNamespaces();
  },

  redeploy: function () {
    this.setState({redeployBtnActive: true});
    request.put('/api/xd/redeploy')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({redeployBtnActive: false});
      }.bind(this));
  },

  redeployNamespace: function (namespace) {
    this.setState({redeployNamespaceBtnActive: true});
    request.put('/api/xd/' + namespace + '/redeploy')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({redeployNamespaceBtnActive: false});
      }.bind(this));
  },

  remove: function () {
    this.setState({removeBtnActive: true});
    request.del('/api/xd/undeploy')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({removeBtnActive: false});
      }.bind(this));
  },

  undeployNamespace: function (namespace) {
    this.setState({undeployNamespaceBtnActive: true});
    request.put('/api/xd/' + namespace + '/undeploy')
      .end(function (res) {
        if (this.isMounted()) {
          if (res.ok) {
            MetaformActions.alert({message: res.text});
          } else {
            MetaformActions.alert(JSON.parse(res.text));
          }
        }
        this.setState({undeployNamespaceBtnActive: false});
      }.bind(this));
  },

  render: function () {
    return (
      <div className="dashboard-actions">
        <h1>Manage Spring XD Environment</h1>
        <br/>
        <div className="row">
          <div className="col-md-3 col-md-offset-1">
            <LaddaButton style="contract" active={this.state.redeployBtnActive}>
              <button type="button" className="btn btn-default btn-lg"
                      onClick={this.redeploy}>Redeploy Everything</button>
            </LaddaButton>
            <div className="btn-group">
              <LaddaButton style="contract" active={this.state.redeployNamespaceBtnActive}>
                <button type="button" className="btn btn-default btn-lg dropdown-toggle"
                        data-toggle="dropdown" aria-expanded="false">
                  Redeploy Namespace <span className="caret"></span>
                </button>
              </LaddaButton>
              <ul className="dropdown-menu" role="menu">
                {this.state.namespaces.map(function (namespace, i) {
                  return (<li key={'ns_' + i}><a href="#" onClick={this.redeployNamespace.bind(this, namespace)}>{namespace}</a></li>);
                }.bind(this))}
              </ul>
            </div>
            <LaddaButton style="contract" active={this.state.removeBtnActive}>
              <button type="button" className="btn btn-default btn-lg"
                      onClick={this.remove}>Undeploy Everything</button>
            </LaddaButton>
            <div className="btn-group">
              <LaddaButton style="contract" active={this.state.undeployNamespaceBtnActive}>
                <button type="button" className="btn btn-default btn-lg dropdown-toggle"
                        data-toggle="dropdown" aria-expanded="false">
                  Undeploy Namespace <span className="caret"></span>
                </button>
              </LaddaButton>
              <ul className="dropdown-menu" role="menu">
                {this.state.namespaces.map(function (namespace, i) {
                  return (<li key={'ns_' + i}><a href="#" onClick={this.undeployNamespace.bind(this, namespace)}>{namespace}</a></li>);
                }.bind(this))}
              </ul>
            </div>
          </div>
          <div className="col-md-4 col-md-offset-1">
            <AddXdJobForm/>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = ManageSpringXd;