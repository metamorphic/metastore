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

var TableDatasets = React.createClass({

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

  download: function (id) {
    var url = '/api/table-datasets/' + id + '/csv';
    request.get(url)
      .end(function (err, res) {
        if (err) {
          AppActions.alert({error: err, message: err});
        } else {
          window.location = url;
        }
      });
  },

  render: function () {
    var view = 'grid';
    var projection = ['name', 'namespace', 'description', 'columns'];
    var nameColumn = 'name';
    var editable = true;
    var sortBy = null;
    var filter = this.props.filter || 'filter';
    var self = this;
    var computedColumns = {
      description: {
        compute: function (row) {
          return (
            <Truncated text={row.description}/>
          );
        }
      },
      columns: {
        compute: function (row) {
          var id = row.id;
          return (
            <Link href={'/grid/table-column/' + row.name + '/by-dataset-and-filter/datasetId=' + id} title="Show Columns">
              <span className="fa fa-columns" aria-hidden="true"></span>
            </Link>
          );
        }
      },
      actions: [
        function (row) {
          return {
            title: 'Fetch sample data',
            iconClassName: 'glyphicon glyphicon-zoom-in',
            onClick: self.fetchSampleData.bind(self, row.id, row.name)
          };
        },
        function (row) {
          return {
            title: 'Download Template',
            iconClassName: 'glyphicon glyphicon-download',
            onClick: self.download.bind(self, row.id)
          };
        }
      ]
    };
    return (
      <div className="grid-with-sample">
        <Grid ref="grid1" source={'$ds1url/table-datasets'} entity="table-dataset"
              projection={projection} nameColumn={nameColumn} sortBy={sortBy} view={view}
              parent={this.props.parent} filter={filter} filterParam={this.props.filterParam}
              computedColumns={computedColumns} editable={editable}/>
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

module.exports = TableDatasets;