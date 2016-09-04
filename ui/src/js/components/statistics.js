/**
 * Created by markmo on 1/05/15.
 */
var React = require('react');
var request = require('superagent');
var Statistic = require('./statistic');

var loading = 'Loading...';

var Statistics = React.createClass({

  redrawRate: 1000,

  getInitialState: function () {
    return {
      numberDatasets: loading,
      totalRecordsProcessed: loading,
      totalEvents: loading
    };
  },

  componentDidMount: function () {
    this.drawEventsByType([]);
    this.drawEventsByDay([]);
    this.drawEventsByMonth([]);
    this.refresh();
  },

  refresh: function () {
    var self = this;
    request.get('/api/stats')
      .end(function (res) {
        if (self.isMounted()) {
          if (res.ok) {
            var json = JSON.parse(res.text);
            self.setState({
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
            self.totalEventsByTypeChart.data = typedata;
            self.totalEventsByTypeChart.draw(self.redrawRate);

            var totalEventsByDay = json.totalEventsByDay;
            var daydata = [];
            for (var key in totalEventsByDay) {
              daydata.push({
                Day: key,
                Count: totalEventsByDay[key]
              });
            }
            self.totalEventsByDayChart.data = daydata;
            self.totalEventsByDayChart.draw(self.redrawRate);

            var totalEventsByMonth = json.totalEventsByMonth;
            var monthdata = [];
            for (var key in totalEventsByMonth) {
              monthdata.push({
                Month: key,
                Count: totalEventsByMonth[key]
              });
            }
            self.totalEventsByMonthChart.data = monthdata;
            self.totalEventsByMonthChart.draw(self.redrawRate);
          }
        }
      });
  },

  drawEventsByType: function (data) {
    var svg = dimple.newSvg("#totalEventsByType", 500, 400);
    var myChart = this.totalEventsByTypeChart = new dimple.chart(svg, data);
    myChart.setBounds(60, 30, 510, 200);
    var x = myChart.addCategoryAxis("x", "Type");
    //x.addOrderRule("Date");
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

  drawEventsByMonth: function (data) {
    var svg = dimple.newSvg("#totalEventsByMonth", 500, 400);
    var myChart = this.totalEventsByMonthChart = new dimple.chart(svg, data);
    myChart.setBounds(60, 30, 510, 200);
    var x = myChart.addCategoryAxis("x", "Month");
    myChart.addMeasureAxis("y", "Count");
    myChart.addSeries(null, dimple.plot.bar);
    myChart.draw();
  },

  render: function () {
    return (
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
          <div id="totalEventsByMonth" className="pull-left"/>
        </div>
        <div className="clearfix">
          <div id="totalEventsByType" className="pull-left"/>
        </div>
      </div>
    );
  }
});

module.exports = Statistics;