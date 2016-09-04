var React = require('react');
var AceEditor = require('react-ace');
var ace  = require('brace');
var DataGrid = require('./data-grid');
var request = require('superagent');
window.$ = window.jQuery = require('jquery');

require('brace/mode/sql');
require('brace/theme/textmate');

var SQLQuery = React.createClass({

  getInitialState: function () {
    return {query: null, q: null, username: null, recent: []};
  },

  componentDidMount: function () {
    this.fetchRecent();
  },

  onChange: function (value) {
    this.query = value;
  },

  go: function () {
    if (this.query && this.query.trim().length) {
      $(this.refs.goBtn.getDOMNode()).button('loading');
      this.setState({query: this.query, q: this.query});
    }
  },

  saveAndGo: function () {
    var username = $(this.refs.username.getDOMNode()).val();
    if (username && username.trim().length && this.query && this.query.trim().length) {
      $(this.refs.saveAndGoBtn.getDOMNode()).button('loading');
      this.setState({query: this.query, q: this.query, username: username});
    }
  },

  handleRefresh: function () {
    $(this.refs.goBtn.getDOMNode()).button('reset');
    $(this.refs.saveAndGoBtn.getDOMNode()).button('reset');
  },

  fetchRecent: function () {
    var self = this;
    var username = $(this.refs.username.getDOMNode()).val();
    if (username && username.trim().length) {
      request.get('/api/sql/recent?username=' + username)
        .end(function (res) {
          if (self.isMounted()) {
            if (res.ok) {
              self.setState({recent: JSON.parse(res.text)});
            }
          }
        });
    }
  },

  refreshRecent: function (event) {
    event.preventDefault();
    this.fetchRecent();
  },

  select: function (i, event) {
    event.preventDefault();
    this.setState({query: this.state.recent[i].query});
  },

  render: function () {
    return (
      <div className="query">
        <div className="row">
          <div className="col-lg-8">
            <AceEditor
              mode='sql'
              theme='textmate'
              name='sql-editor'
              onChange={this.onChange}
              width='100%'
              height='160px'
              value={this.state.query}
              />
            <div className="query-btn-group clearfix">
              <button ref="goBtn" className="btn btn-default pull-right" type="button"
                      onClick={this.go} data-loading-text="Loading...">Go</button>
              <div className="save-go pull-right">
                <div className="input-group">
                  <input ref="username" type="text" className="form-control" placeholder="Username for save"/>
                  <span className="input-group-btn">
                    <button ref="saveAndGoBtn" className="btn btn-default" type="button"
                            onClick={this.saveAndGo} data-loading-text="Loading...">Save &amp; Go</button>
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div className="col-lg-4">
            <div className="list-group">
              {this.state.recent.map(function (q, i) {
                return (
                  <a href="#" className="list-group-item" onClick={this.select.bind(this, i)}>
                    {q.query}
                  </a>
                );
              }.bind(this))}
            </div>
            <div className="query-btn-group clearfix">
              <button className="btn btn-small pull-right" type="button" onClick={this.refreshRecent}>
                <i className="fa fa-refresh"></i>
              </button>
              <span>{this.state.recent.length ? 'Recent queries' : null}</span>
            </div>
          </div>
        </div>
        <DataGrid staticHeight="465" query={this.state.q}
                  username={this.state.username} onRefresh={this.handleRefresh.bind(this)}/>
      </div>
    );
  }
});

module.exports = SQLQuery;