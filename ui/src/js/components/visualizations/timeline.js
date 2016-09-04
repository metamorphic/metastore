var React = require('react');
var vis = require('vis');
var request = require('superagent');
window.$ = window.jQuery = require('jquery');

var colors = ['green', 'red', 'blue', 'purple', 'aquamarine'];

var Timeline = React.createClass({

  shouldComponentUpdate: function(nextProps, nextState) {
    return nextProps.customerIdTypeId && nextProps.customerId;
  },

  render: function () {
    if (this.props.customerIdTypeId && this.props.customerId) {
      request.get('/api/viz/timeline?customerIdTypeId=' + this.props.customerIdTypeId + '&customerId=' + this.props.customerId)
        .end(function (res) {
          if (this.isMounted()) {
            if (res.ok) {
              var typeobj = {};
              var data = JSON.parse(res.text);
              var i;
              for (i = 0; i < data.length; i++) {
                typeobj[data[i].content] = 1;
              }
              var types = [];
              for (var type in typeobj) {
                types.push(type);
              }
              for (i = 0; i < data.length; i++) {
                data[i].className = colors[types.indexOf(data[i].content)] || 'orange';
              }
              $(this.refs.timeline1.getDOMNode()).empty();
              var dataset = new vis.DataSet(data);
              new vis.Timeline(this.refs.timeline1.getDOMNode(), dataset, {
                type: 'point',
                showMajorLabels: false
              });
            }
          }
        }.bind(this));
    }
    return (
      <div ref="timeline1"/>
    );
  }
});

module.exports = Timeline;