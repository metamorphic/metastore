var React = require('react');
var Sankey = require('./sankey');

var SankeyVisualization = React.createClass({

  render: function () {
    return (
      <div>
        <h1>Event Flow</h1>
        <Sankey/>
      </div>
    );
  }
});

module.exports = SankeyVisualization;