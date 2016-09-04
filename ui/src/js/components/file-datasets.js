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
var Inspector = require('react-json-inspector');
window.$ = window.jQuery = require('jquery');

var FileDatasets = React.createClass({

  getInitialState: function () {
    return {url: null, fileType: null, data: {}};
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
    $('.json-inspector').hide();
  },

  reimportDataset: function (id) {
    request.put('/api/file-datasets/' + id + '/reimport')
      .end(function (err, res) {
        if (res.ok) {
          AppActions.alert({message: res.text});
        } else {
          AppActions.alert(JSON.parse(res.text));
        }
      });
  },

  fetchSampleData: function (id, name, fileType) {
    var self = this;
    var url = '/api/file-datasets/' + id + '/sample';
    if (fileType === 'JSON') {
      url += 'json';
      request.get(url)
        .end(function (res) {
          if (self.isMounted()) {
            if (res.ok) {
              var data = JSON.parse(res.text);
              $('.json-inspector').show();
              self.setState({data: data, datasetName: name, fileType: fileType});
            } else {
              AppActions.alert(JSON.parse(res.text));
            }
          }
        });
    } else {
      this.setState({url: url, datasetName: name, fileType: fileType});
    }
  },

  componentDidUpdate: function (prevProps, prevState) {
    $('#repeater1').repeater('render');
  },

  render: function () {
    var view = 'grid';
    var projection = ['id', 'name', 'namespace', 'description', 'drilldown'];
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
      drilldown: {
        compute: function (row) {
          var id = row.id;
          if (row.multiRecordset) {
            return (
              <Link href={'/grid/record/' + row.name + '/by-dataset/datasetId=' + id} title="Show Records">
                <span className="glyphicon glyphicon-tasks" aria-hidden="true"></span>
              </Link>
            );
          } else {
            return (
              <Link href={'/grid/file-column/' + row.name + '/by-dataset-and-filter/datasetId=' + id} title="Show Columns">
                <span className="fa fa-columns" aria-hidden="true"></span>
              </Link>
            );
          }
        }
      },
      actions: [
        function (row) {
          return {
            title: 'Fetch sample data',
            iconClassName: 'glyphicon glyphicon-zoom-in',
            onClick: self.fetchSampleData.bind(self, row.id, row.name, row.fileType)
          };
        },
        function (row) {
          return {
            title: 'Reimport columns and properties',
            iconClassName: 'fa fa-upload',
            onClick: self.reimportDataset.bind(self, row.id)
          };
        }
        //function (row) {
        //  return (
        //    <Link href={'/grid/event-property-types/' + row.name + '/by-dataset/id=' + row.id}>
        //      Show Event Property Types
        //      <i className="fa fa-list" aria-hidden="true"></i>
        //    </Link>
        //  );
        //}
      ]
    };
    return (
      <div className="grid-with-sample">
        <Grid ref="grid1" source={'$ds1url/file-datasets'} entity="file-dataset"
              projection={projection} nameColumn={nameColumn} sortBy={sortBy} view={view}
              parent={this.props.parent} filter={filter} filterParam={this.props.filterParam}
              computedColumns={computedColumns} editable={editable}/>
        <p><strong>{this.state.datasetName}</strong></p>
        <div className="repeater" id="repeater1" data-staticheight="465" style={{display: (this.state.url && (this.state.fileType !== 'JSON')) ? 'block' : 'none'}}>
          <div className="repeater-viewport">
            <div className="repeater-canvas scrolling"></div>
            <div className="loader repeater-loader"></div>
          </div>
        </div>
        <Inspector data={this.state.data} style={{display: (this.state.fileType === 'JSON') ? 'block' : 'none'}}/>
      </div>
    );
  }
});

module.exports = FileDatasets;