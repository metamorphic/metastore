var React = require('react');
var Grid = require('metaform').Grid;
var pluralize = require('pluralize');
var bootstrap = require('bootstrap');
var request = require('superagent');
var AppActions = require('metaform').AppActions;
var Link = require('react-router-component').Link;
var Truncated = require('metaform').Truncated;

var Metagrid = React.createClass({

  makeEventPropertyType: function (link) {
    var url;
    var i = link.indexOf('{');
    if (i === -1) {
      url = link;
    } else {
      url = link.substring(0, i);
    }
    url += '?projection=grid';
    var self = this;
    request.get(url)
      .end(function (res) {
        if (res.ok) {
          var json = JSON.parse(res.text);
          var name = 'd' + ('000000' + json.datasetId).slice(-6) + '_' + json.name;
          var data = {
            name: name,
            // TODO
            // this is in wrong format
            //valueType: json._links.valueType.href,
            description: json.description,
            mappingExpression: "#this['" + json.name + "']"
          };
          request.post("/api/event-property-types")
            .send(data)
            .end(function (err, resp) {
              // The location header is considered unsafe. The reason is that
              // by manipulating these headers you might be able to trick the
              // server into accepting a second request through the same
              // connection, one that wouldn't go through the usual security
              // checks. However, this is how Spring Data REST returns the id
              // of the newly created entity. The server must return a
              // response header of "Access-Control-Expose-Headers: Location",
              // which has been added to metastore.CORSFilter.
              request.patch(link)
                .send({
                  eventPropertyTypes: [resp.header['location']]
                })
                .end(function (err, response) {
                  if (err) {
                    AppActions.alert(err);
                  } else {
                    AppActions.alert({message: "Created property '" + name + "'"});
                    self.refs.grid1.refresh();
                  }
                });
            });
        }
      })
  },

  //reimportDataset: function (id) {
  //  request.put('/api/file-datasets/' + id + '/reimport')
  //    .end(function (err, res) {
  //      if (res.ok) {
  //        AppActions.alert({message: res.text});
  //      } else {
  //        AppActions.alert(JSON.parse(res.text));
  //      }
  //    });
  //},

  reimportTableDataset: function (id) {
    var mprogress = new Mprogress({template: 3, start: true});
    request.put('/api/table-data-sources/' + id + '/reimport')
      .end(function (err, res) {
        if (res.ok) {
          AppActions.alert({message: res.text});
        } else {
          AppActions.alert(JSON.parse(res.text));
        }
        mprogress.end();
      });
  },

  deleteJobEvents: function (jobId) {
    request.put('/api/jobs/' + jobId + '/delete-events')
      .end(function (res) {
        if (res.ok) {
          AppActions.alert({message: res.text});
        } else {
          AppActions.alert(JSON.parse(res.text));
        }
      });
  },

  redeployStream: function (streamId) {
    request.put('/api/streams/' + streamId + '/deploy')
      .end(function (res) {
        if (res.ok) {
          AppActions.alert({message: res.text});
        } else {
          AppActions.alert(JSON.parse(res.text));
        }
      });
  },

  redeployXdJob: function (jobId) {
    request.put('/api/xd-jobs/' + jobId + '/deploy')
      .end(function (res) {
        if (res.ok) {
          AppActions.alert({message: res.text});
        } else {
          AppActions.alert(JSON.parse(res.text));
        }
      });
  },

  cloneTableDataSource: function (dataSourceId) {
    request.post('/api/table-data-sources/' + dataSourceId + '/clone')
      .end(function (res) {
        if (res.ok) {
          AppActions.alert({message: res.text});
          this.refs.grid1.refresh();
        } else {
          AppActions.alert(JSON.parse(res.text));
        }
      }.bind(this));
  },

  render: function () {
    var projection, computedColumns = null, sortBy = null, order = null, view = null, url;
    var filter = this.props.filter;
    var name = this.props.name || 'file-dataset';
    var nameColumn = 'name';
    var editable = true;
    var self = this;

    if (name == 'file-data-source') {
      filter = filter || 'filter';
      projection = ['name', 'description'];
      computedColumns = {
        description: {
          compute: function (row) {
            return (
              <Truncated text={row.description}/>
            );
          }
        }
      };

    //} else if (name === 'file-dataset') {
    //  view = 'grid';
    //  filter = filter || 'filter';
    //  projection = ['name', 'namespace', 'description', 'drilldown', 'reimport'];
    //  computedColumns = {
    //    drilldown: {
    //      compute: function (row) {
    //        var id = row.id;
    //        if (row.multiRecordset) {
    //          return (
    //            <Link href={'/grid/record/' + row.name + '/by-dataset/datasetId=' + id} title="Show Records">
    //              <span className="glyphicon glyphicon-tasks" aria-hidden="true"></span>
    //            </Link>
    //          );
    //        } else {
    //          return (
    //            <Link href={'/grid/file-column/' + row.name + '/by-dataset-and-filter/datasetId=' + id} title="Show Columns">
    //              <span className="fa fa-columns" aria-hidden="true"></span>
    //            </Link>
    //          );
    //        }
    //      }
    //    },
    //    reimport: {
    //      compute: function (row) {
    //        return (
    //          <a href="#" onClick={self.reimportDataset.bind(self, row.id)} title="Reimport columns and properties">
    //            <i className="fa fa-upload" aria-hidden="true"></i>
    //          </a>
    //        );
    //      }
    //    },
    //    propertyTypes: {
    //      compute: function (row) {
    //        return (
    //          <Link href={'/grid/event-property-types/' + row.name + '/by-dataset/id=' + row.id} title="Show Event Property Types">
    //            <i className="fa fa-list" aria-hidden="true"></i>
    //          </Link>
    //        );
    //      }
    //    }
    //  };

    } else if (name === 'table-data-source') {
      view = 'grid';
      filter = filter || 'filter';
      projection = ['name', 'description'];
      computedColumns = {
        description: {
          compute: function (row) {
            return (
              <Truncated text={row.description}/>
            );
          }
        },
        actions: [
          function (row) {
            var id = /\/(\d+)$/.exec(row._links.self.href)[1];
            return {
              title: 'Reimport dataset',
              iconClassName: 'fa fa-upload',
              onClick: self.reimportTableDataset.bind(self, id)
            };
          },
          function (row) {
            var id = /\/(\d+)$/.exec(row._links.self.href)[1];
            return {
              title: 'Clone this source',
              iconClassName: 'fa fa-copy',
              onClick: self.cloneTableDataSource.bind(self, id)
            };
          }
        ]
      };

    //} else if (name === 'table-dataset') {
    //  view = 'grid';
    //  filter = filter || 'filter';
    //  projection = ['name', 'namespace', 'description', 'columns'];
    //  computedColumns = {
    //    description: {
    //      compute: function (row) {
    //        return (
    //          <Truncated text={row.description}/>
    //        );
    //      }
    //    },
    //    columns: {
    //      compute: function (row) {
    //        var id = row.id;
    //        return (
    //          <Link href={'/grid/table-column/' + row.name + '/by-dataset-and-filter/datasetId=' + id} title="Show Columns">
    //            <span className="fa fa-columns" aria-hidden="true"></span>
    //          </Link>
    //        );
    //      }
    //    }
    //  };

    } else if (name === 'record') {
      view = 'grid';
      projection = ['name', 'prefix', 'columns'];
      computedColumns = {
        columns: {
          compute: function (row) {
            var id = row.id;
            return (
              <Link href={'/grid/file-column/' + row.name + '/by-record/id=' + id} title="Show Columns">
                <span className="glyphicon glyphicon-zoom-in" aria-hidden="true"></span>
              </Link>
            );
          }
        }
      };

    } else if (name === 'file-column') {
      view = 'grid';
      projection = ['name', 'columnIndex', 'dataTypeName', 'description'];
      sortBy = 'columnIndex';
      filter = filter || 'filter';
      computedColumns = {
        description: {
          compute: function (row) {
            return (
              <Truncated text={row.description}/>
            );
          }
        },
        actions: [
          function (row) {
            var link = row._links.self.href;
            return {
              title: 'Make Property Type',
              iconClassName: 'fa fa-list',
              onClick: self.makeEventPropertyType.bind(self, link)
            };
          }
        ]
      };

    //} else if (name === 'table-column') {
    //  view = 'grid';
    //  projection = ['name', 'columnIndex', 'dataTypeName', 'description'];
    //  sortBy = 'columnIndex';
    //  filter = filter || 'filter';
    //  computedColumns = {
    //    description: {
    //      compute: function (row) {
    //        return (
    //          <Truncated text={row.description}/>
    //        );
    //      }
    //    }
    //  };

    } else if (name === 'transformation') {
      view = 'grid';
      projection = ['name', 'inputDatasetsName', 'outputDatasetName', 'language', 'description'];
      filter = filter || 'filter';
      computedColumns = {
        description: {
          compute: function (row) {
            return (
              <Truncated text={row.description}/>
            );
          }
        }
      };

    } else if (name === 'event-type') {
      view = 'grid';
      filter = filter || 'filter';
      projection = ['id', 'name', 'namespace', 'description', 'properties'];
      computedColumns = {
        description: {
          compute: function (row) {
            return (
                <Truncated text={row.description}/>
            );
          }
        },
        properties: {
          compute: function (row) {
            var id = row.id;
            return (
                <Link href={'/grid/event-property/' + row.name + '/by-event-type-and-filter/eventTypeId=' + id}
                      title="Show Properties">
                  <span className="fa fa-columns" aria-hidden="true"></span>
                </Link>
            );
          }
        }
      };

    } else if (name === 'event-property-type') {
      view = 'grid';
      filter = filter || 'filter';
      projection = ['id', 'name', 'valueTypeName'];

    } else if (name === 'feature-family') {
      view = 'grid';
      filter = filter || 'filter';
      projection = ['name', 'wideTableName'];

    } else if (name === 'feature-type') {
      view = 'grid';
      filter = filter || 'filter';
      projection = ['id', 'name', 'type', 'language', 'authorName'];

    } else if (name === 'feature-test') {
      view = 'grid';
      nameColumn = 'description';
      filter = filter || 'filter';
      projection = ['featureTypeName', 'description', 'status', 'authorName'];

    } else if (name === 'model') {
      view = 'grid';
      nameColumn = 'name';
      filter = filter || 'filter';
      projection = ['name', 'version', 'committer', 'description'];

    } else if (name === 'model-package') {
      view = 'grid';
      nameColumn = 'name';
      filter = filter || 'filter';
      projection = ['name', 'version', 'description'];

    } else if (name === 'customer-id-type') {
      view = 'grid';
      filter = filter || 'filter';
      projection = ['id', 'name', 'valueTypeName', 'composite'];

    } else if (name === 'customer-id-mapping-rule') {
      view = 'grid';
      projection = ['name', 'customerIdType1Name', 'customerIdType2Name'];

    } else if (name === 'job') {
      view = 'grid';
      projection = ['id', 'datasetId', 'sourceFilename', 'start', 'end', 'status', 'recordsProcessed', 'recordsSkipped', 'eventsCreated', 'errorsLogged', 'rollbackEvents'];
      nameColumn = 'id';
      sortBy = 'start';
      order = 'desc';
      editable = false;
      computedColumns = {
        rollbackEvents: {
          compute: function (row) {
            return (
              <a href="#" onClick={self.deleteJobEvents.bind(self, row.id)}>
                <i className="fa fa-trash-o" aria-hidden="true"></i>
              </a>
            );
          }
        }
      };

    } else if (name === 'test-job') {
      view = 'grid';
      projection = ['id', 'datasetId', 'sourceFilename', 'start', 'end', 'status', 'recordsProcessed', 'recordsSkipped', 'eventsCreated', 'errorsLogged'];
      nameColumn = 'id';
      sortBy = 'start';
      order = 'desc';
      editable = false;

    } else if (name === 'setting') {
      view = 'grid';
      projection = ['name'];

    } else if (name === 'xd-job') {
      view = 'grid';
      projection = ['name', 'makeUnique', 'redeploy'];
      editable = true;
      computedColumns = {
        makeUnique: {
          compute: function (row) {
            if (row.makeUnique) {
              return  (<i className="fa fa-check" aria-hidden="true"></i>);
            } else {
              return  (<i className="fa fa-times" aria-hidden="true"></i>);
            }
          }
        },
        redeploy: {
          compute: function (row) {
            return (
              <a href="#" onClick={self.redeployXdJob.bind(self, row.id)}>
                <i className="fa fa-play-circle-o" aria-hidden="true"></i>
              </a>
            );
          }
        }
      };

    } else if (name === 'stream') {
      view = 'grid';
      projection = ['name', 'namespace', 'pollingDirectory', 'filenamePattern', 'preventDups', 'job', 'redeploy'];
      computedColumns = {
        preventDups: {
          compute: function (row) {
            if (row.preventDuplicates) {
              return  (<i className="fa fa-check" aria-hidden="true"></i>);
            } else {
              return  (<i className="fa fa-times" aria-hidden="true"></i>);
            }
          }
        },
        redeploy: {
          compute: function (row) {
            return (
              <a href="#" onClick={self.redeployStream.bind(self, row.id)}>
                <i className="fa fa-play-circle-o" aria-hidden="true"></i>
              </a>
            );
          }
        }
      };
    } else {
      projection = ['name'];
    }

    if (this.props.parentId) {
      url = this.props.parentType + '/' + this.props.parentId + '/' + this.props.childProperty;
    } else {
      url = pluralize(name);
    }

    return (
      <Grid ref="grid1" source={'$ds1url/' + url} entity={name}
        projection={projection} nameColumn={nameColumn}
        sortBy={sortBy} order={order} view={view}
        parent={this.props.parentName} filter={filter} filterParam={this.props.filterParam}
        computedColumns={computedColumns} editable={editable}/>
        // computedColumns={{
        //   name: {
        //     sortBy: 'lastName',
        //     compute: function (row) {
        //       return row.firstName + ' ' + row.lastName;
        //     }
        //   }
        //}}/>
    );
  }
});

module.exports = Metagrid;