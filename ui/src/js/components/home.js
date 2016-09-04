/**
 * Created by markmo on 1/05/15.
 */
var React = require('react');
var request = require('superagent');
var Statistic = require('./statistic');
var Link = require('react-router-component').Link;
var StoreWatchMixin = require('../mixins/store-watch-mixin');
var AppStore = require('../stores/app-store');
var AppActions = require('../actions/app-actions');
var SearchResults = require('./search-results');
window.$ = window.jQuery = require('jquery');

var loading = 'Loading...';

var isSearchOpen = false;

function keydown(ev) {
  var keyCode = ev.keyCode || ev.which;
  if (keyCode === 27 && isSearchOpen) {
    this.toggleSearch(ev);
  }
}

var Home = React.createClass({

  mixins: [StoreWatchMixin(getSearchHits)],

  redrawRate: 1000,

  getInitialState: function () {
    return {
      numberDatasets: loading,
      totalRecordsProcessed: loading,
      totalEvents: loading,
      searchResultsVisible: false
    };
  },

  componentDidMount: function () {
    var self = this;
    //$(this.refs.search1.getDOMNode()).search();
    //$(this.refs.search1.getDOMNode()).on('searched.fu.search', function () {
    //  //$(this).find('input').val('Not yet implemented, sorry');
    //  AppActions.searchEntities($(this).find('input').val());
    //  self.setState({searchResultsVisible: true});
    //}).on('cleared.fu.search', function () {
    //  self.setState({searchResultsVisible: false});
    //});

    this.drawEventsByType([]);
    this.drawEventsByDay([]);
    this.fetch();

    // esc key closes search overlay
    document.addEventListener('keydown', keydown.bind(this));
  },

  componentWillUnmount: function () {
    $(this.refs.search1.getDOMNode()).off();
      //.off('searched.fu.search')
      //.off('cleared.fu.search');
    document.removeEventListener('keydown', keydown);
    isSearchOpen = false;
  },

  fetch: function () {
    var self = this;
    request.get('/api/stats')
      .end(function (res) {
        if (self.isMounted()) {
          if (res.ok) {
            var json = JSON.parse(res.text);
            self.redraw(json);
          }
        }
      });
  },

  refresh: function () {
    var self = this;
    request.get('/api/stats/refresh')
      .end(function (res) {
        if (self.isMounted()) {
          if (res.ok) {
            var json = JSON.parse(res.text);
            self.redraw(json);
          }
        }
      });
  },

  redraw: function (json) {
    this.setState({
      numberDatasets: json.numberDatasets,
      totalRecordsProcessed: json.totalRecordsProcessed,
      totalEvents: json.totalEvents
    });
    var totalEventsByType = json.totalEventsByType;
    var typedata = [];
    for (var key in totalEventsByType) {
      typedata.push({
        Type: key,
        Count: totalEventsByType[key]
      });
    }
    this.totalEventsByTypeChart.data = typedata;
    this.totalEventsByTypeChart.draw(this.redrawRate);

    var totalEventsByDay = json.totalEventsByDay;
    var daydata = [];
    for (var key in totalEventsByDay) {
      daydata.push({
        Day: key,
        Count: totalEventsByDay[key]
      });
    }
    this.totalEventsByDayChart.data = daydata;
    this.totalEventsByDayChart.draw(this.redrawRate);
  },

  drawEventsByType: function (data) {
    var svg = dimple.newSvg("#totalEventsByType", 500, 400);
    var myChart = this.totalEventsByTypeChart = new dimple.chart(svg, data);
    myChart.setBounds(60, 30, 510, 200);
    var x = myChart.addCategoryAxis("x", "Type");
    myChart.addMeasureAxis("y", "Count");
    myChart.addSeries(null, dimple.plot.bar);
    myChart.draw();
  },

  drawEventsByDay: function (data) {
    var svg = dimple.newSvg("#totalEventsByDay", 500, 400);
    var myChart = this.totalEventsByDayChart = new dimple.chart(svg, data);
    myChart.setBounds(60, 30, 510, 200);
    var x = myChart.addCategoryAxis("x", "Day");
    myChart.addMeasureAxis("y", "Count");
    myChart.addSeries(null, dimple.plot.bar);
    myChart.draw();
  },

  toggleSearch: function (event) {
    if (event.type.toLowerCase() === 'focus' && isSearchOpen) {
      return false;
    }
    var search1 = this.refs.search1.getDOMNode();
    var searchInput = this.refs.searchInput.getDOMNode();
    var self = this;
    if (isSearchOpen) {
      classie.remove(search1, 'open');

      // trick to hide input text once the search overlay closes
      if (searchInput.value !== '') {
        setTimeout(function () {
          classie.add(search1, 'hideInput');
          setTimeout(function () {
            classie.remove(search1, 'hideInput');
            searchInput.value = '';
            self.setState({searchResultsVisible: false});
          }, 300);
        }, 500);
      }
      searchInput.blur();
    } else {
      classie.add(search1, 'open');
    }
    isSearchOpen = !isSearchOpen;
  },

  handleSearchSubmit: function (event) {
    event.preventDefault();
    AppActions.searchEntities(this.refs.searchInput.getDOMNode().value);
    this.setState({searchResultsVisible: true});
  },

  render: function () {
    return (
      <div className="home">
        <div className="actions">
          <Link href="/event-wizard" className="btn btn-default btn-lg">Define a new Event</Link>
        </div>
        <div ref="search1" className="morphsearch">
          <form className="morphsearch-form" onSubmit={this.handleSearchSubmit}>
            <input ref="searchInput" className="morphsearch-input" type="search"
                   placeholder="Search..." onFocus={this.toggleSearch}/>
            <button className="morphsearch-submit" type="submit">Search</button>
          </form>
          <div className="morphsearch-content">
            <SearchResults hits={this.state.hits} visible={this.state.searchResultsVisible}/>
          </div>
          <span className="morphsearch-close" onClick={this.toggleSearch}></span>
        </div>
        <div className="statistics">
          <button className="btn btn-small pull-right" onClick={this.refresh}>
            <i className="fa fa-refresh"></i>
          </button>
          <div className="row">
            <Statistic value={this.state.numberDatasets} numberFormat="0,0" label="Datasets"/>
            <Statistic value={this.state.totalRecordsProcessed} numberFormat="0,0" label="Records Processed"/>
            <Statistic value={this.state.totalEvents} numberFormat="0,0" label="Events"/>
          </div>
          <div className="clearfix charts">
            <div id="totalEventsByDay" className="pull-left"/>
            <div id="totalEventsByType" className="pull-left"/>
          </div>
        </div>
      </div>
    );
  }
});
/*
<div className="row search-bar">
  <div className="col-lg-4 col-lg-offset-4">
    <div className="search input-group" role="search" ref="search1" data-initialize="search">
      <input type="search" className="form-control" placeholder="Search"/>
      <span className="input-group-btn">
        <button className="btn btn-default" type="button">
          <span className="glyphicon glyphicon-search"></span>
          <span className="sr-only">Search</span>
        </button>
      </span>
    </div>
  </div>
</div>
<SearchResults hits={this.state.hits} visible={this.state.searchResultsVisible}/>
*/

function getSearchHits() {
  return {hits: AppStore.getSearchHits()};
}

module.exports = Home;