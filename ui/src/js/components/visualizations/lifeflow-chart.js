/**
 * Created by markmo on 20/05/15.
 */
var React = require('react');
var evtData = require('./lifeflow/evt-data');
var flowChart = require('./lifeflow/lifeflow-chart');
var lifeflow = require('./lifeflow/lifeflow');

var LifeflowChart = React.createClass({

  componentDidMount: function () {
    var tooltip = d3.select('#lifeflow1')
      .style('position', 'absolute')
      .style('z-index', '10')
      .style('visibility', 'hidden')
      .text('a simple tooltip');
    d3.csv('/api/viz/lifeflow?n=1000', function (data) {
      var container = d3.select('#lifeflow1');
      var lifeflowChart = nv.models.lifeflowChart()
          .entityIdProp('hur_id')
          .eventNameProp('status')
          .startDateProp('date')
          .eventOrder([
            'Subtropical storm',
            'Genesis',
            'Disturbance',
            'Subtropical Depression',
            'Tropical Wave',
            'Tropical Depression',
            'Tropical Storm',
            'Hurricane',
            'Landfall',
            'Extratropical',
            'Low',
            'Intensity Peak',
            'Maximum wind',
            'Status change'])
          .unitProp(1000 * 60 * 60) // hours
          .height(window.innerHeight - 100)
          .width(window.innerWidth - 100)
        ;
      container
        .datum(data)
        .call(lifeflowChart);
    });
  },

  render: function () {
    return (
      <div id="lifeflow1"/>
    );
  }
});

module.exports = LifeflowChart;