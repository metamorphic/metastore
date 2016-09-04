/**
 * Created by markmo on 3/05/15.
 */
var React = require('react');
var fuelux = require('fuelux');
var request = require('superagent');
var AppActions = require('metaform').AppActions;
window.$ = window.jQuery = require('jquery');

var DataGrid = React.createClass({

  componentDidMount: function () {
    var self = this;
    var dataSource = function (options, callback) {
      var q = self.props.query;
      if (q && (q = q.trim()).length) {
        //if (!q.match(/\sLIMIT\s/gi)) {
        //  if (q.endsWith(';')) {
        //    q = q.slice(0, -1);
        //  }
        //  q += '\nLIMIT ' + options.pageSize + ' OFFSET ' + (options.pageIndex * options.pageSize) + ';';
        //}
        var url = '/api/sql?q=' + encodeURI(q);
        if (self.props.username) {
          url += '&username=' + self.props.username;
        }
        request.get(url)
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

  shouldComponentUpdate: function (nextProps, nextState) {
    return nextProps.query != this.props.query;
  },

  render: function () {
    $('#repeater1').repeater('render');
    return (
      <div className="repeater" id="repeater1" data-staticheight={this.props.staticHeight}>
        <div className="repeater-viewport">
          <div className="repeater-canvas scrolling"></div>
          <div className="loader repeater-loader"></div>
        </div>
      </div>
    );
  }
});
//<div className="repeater-footer">
//  <div className="repeater-footer-left">
//    <div className="repeater-itemization">
//      <span><span className="repeater-start"></span> - <span className="repeater-end"></span> of <span className="repeater-count"></span> items</span>
//      <div className="btn-group selectlist" data-resize="auto">
//        <button className="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
//          <span className="selected-label">&nbsp;</span>
//          <span className="caret"></span>
//          <span className="sr-only">Toggle Dropdown</span>
//        </button>
//        <ul className="dropdown-menu" role="menu">
//          <li data-value="5"><a href="#">5</a></li>
//          <li data-value="10" data-selected="true"><a href="#">10</a></li>
//          <li data-value="20"><a href="#">20</a></li>
//          <li data-value="50" data-foo="bar" data-fizz="buzz"><a href="#">50</a></li>
//          <li data-value="100"><a href="#">100</a></li>
//        </ul>
//        <input className="hidden hidden-field" name="itemsPerPage" readonly="readonly" aria-hidden="true" type="text"/>
//      </div>
//      <span>Per Page</span>
//    </div>
//  </div>
//  <div className="repeater-footer-right">
//    <div className="repeater-pagination">
//      <button className="btn btn-default btn-sm repeater-prev" type="button">
//        <span className="glyphicon glyphicon-chevron-left"></span>
//        <span className="sr-only">Previous Page</span>
//      </button>
//      <label className="page-label" id="myPageLabel">Page</label>
//      <div className="repeater-primaryPaging active">
//        <div className="input-group input-append dropdown combobox">
//          <input className="form-control" type="text" aria-labelledby="myPageLabel"/>
//          <div className="input-group-btn">
//            <button className="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
//              <span className="caret"></span>
//              <span className="sr-only">Toggle Dropdown</span>
//            </button>
//            <ul className="dropdown-menu dropdown-menu-right"></ul>
//          </div>
//        </div>
//      </div>
//      <input className="form-control repeater-secondaryPaging" type="text" aria-labelledby="myPageLabel"/>
//      <span>of <span className="repeater-pages"></span></span>
//      <button className="btn btn-default btn-sm repeater-next" type="button">
//        <span className="glyphicon glyphicon-chevron-right"></span>
//        <span className="sr-only">Next Page</span>
//      </button>
//    </div>
//  </div>
//</div>

module.exports = DataGrid;