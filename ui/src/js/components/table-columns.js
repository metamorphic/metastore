/**
 * Created by markmo on 4/05/15.
 */
var React = require('react');
var M = require('metaform');
var AppActions = M.AppActions;
var Grid = M.Grid;
var Truncated = M.Truncated;
var Link = require('react-router-component').Link;
var fuelux = require('fuelux');
var request = require('superagent');
window.$ = window.jQuery = require('jquery');

var TableColumns = React.createClass({

  getInitialState: function () {
    return {url: null, data: {}};
  },

  componentDidMount: function () {
    var self = this;
    var dataSource = function (options, callback) {
      if (self.state.url) {
        request.get(self.state.url)
          .end(function (res) {
            if (self.isMounted()) {
              if (res.ok) {
                var items = JSON.parse(res.text);
                var columns = [];
                if (items && items.length) {
                  for (var key in items[0]) {
                    columns.push({
                      label: key,
                      property: key,
                      sortable: false
                    });
                  }
                }
                callback({
                  page: 1,
                  pages: 1,
                  count: 1,
                  start: 1,
                  end: 1,
                  columns: columns,
                  items: items
                })
              } else {
                AppActions.alert(JSON.parse(res.text));
              }
            }
            if (typeof self.props.onRefresh == 'function') {
              self.props.onRefresh();
            }
          });
      } else {
        callback({
          page: 0,
          pages: 0,
          count: 0,
          start: 0,
          end: 0,
          columns: [],
          items: []
        });
      }
    };
    $('#repeater1').repeater({dataSource: dataSource});
  },

  componentDidUpdate: function (prevProps, prevState) {
    $('#repeater1').repeater('render');
  },

  fetchSampleData: function (id, name) {
    var url = '/api/table-datasets/' + id + '/sample';
    this.setState({url: url, datasetName: name});
  },

  render: function () {
    var view = 'grid';
    var projection = ['name', 'columnIndex', 'dataTypeName', 'description'];
    var nameColumn = 'name';
    var editable = true;
    var sortBy = 'columnIndex';
    var filter = this.props.filter || 'filter';
    var computedColumns = {
      description: {
        compute: function (row) {
          return (
            <Truncated text={row.description}/>
          );
        }
      }
    };
    var datasetId = this.props.filterParam.split('=')[1];
    var datasetName = this.props.parentName;
    return (
      <div className="table-columns grid-with-sample">
        <Grid ref="grid1" source={'$ds1url/table-columns'} entity="table-column"
              projection={projection} nameColumn={nameColumn} sortBy={sortBy} view={view}
              parent={this.props.parent} filter={filter} filterParam={this.props.filterParam}
              computedColumns={computedColumns} editable={editable}/>
        <nav className="cl-effect-13" id="cl-effect-13">
          <a href="#cl-effect-13" onClick={this.fetchSampleData.bind(this, datasetId, datasetName)}>
            Fetch Sample Data
          </a>
        </nav>
        <p><strong>{this.state.datasetName}</strong></p>
        <div className="repeater" id="repeater1" data-staticheight="465" style={{display: this.state.url ? 'block' : 'none'}}>
          <div className="repeater-viewport">
            <div className="repeater-canvas scrolling"></div>
            <div className="loader repeater-loader"></div>
          </div>
        </div>
      </div>
    );
  }
});

module.exports = TableColumns;