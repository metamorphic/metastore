var React = require('react');
var Tree = require('./tree');

var TreeVisualization = React.createClass({

  render: function () {
    return (
      <div>
        <h1>Next Event Pathways</h1>
        <Tree/>
      </div>
    );
  }
});

module.exports = TreeVisualization;