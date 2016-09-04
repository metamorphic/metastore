/**
 * Created by markmo on 20/05/15.
 */

'use strict';
var lifeflowBare = function () {

  //============================================================
  // Public Variables with Default Settings
  //------------------------------------------------------------

  var margin = {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    }
    , lifeflowData
    , timelineData
    , eventNames = null
    , alignChoices
    , alignmentLineWidth = 28
    , eventNodeWidth = 0
    , width
    , height
    , id = Math.floor(Math.random() * 10000) //Create semi-unique ID in case user doesn't select one
    , x = d3.scale.linear()
    , y = d3.scale.linear()
    , relativeX
    , color = d3.scale.category20()
    , alignBy
    , dispatch = d3.dispatch('chartClick', 'elementClick', 'elementDblClick',
          'elementMouseover', 'elementMouseout', 'toggleEvt', 'alignBy',
          'selectRecs', 'doneDrawing', 'areaClick', 'tooltipHide',
          'tooltipShow', 'lifeflowMouseover', 'lifeflowMouseout')
    ;

  function chart(selection) {
    selection.each(function (data) {
      lifeflowData = data;
      y.range([0, height]);
      x.range([0, width]);
      x.domain([
        d3.min([0].concat(lifeflowData.map(function (d) {
          return d.x() + d.dx()
        }))),
        d3.max([0].concat(lifeflowData.map(function (d) {
          return d.x() + d.dx()
        })))
      ]);
      relativeX = d3.scale.linear()
        .range(x.range())
        .domain([0, x.domain()[1] - x.domain()[0]]);
      var container = d3.select(this);
      var nodes = container.selectAll('g.event-node')
        .data(lifeflowData, function (d) {
          var id = chart.alignBy() + d.namePath({noRoot: false}) + d.backwards;
          d.joinId = id;
          return id;
          // paths can be the same on either
          // side of an alignment, so include backwards flag
        });
      y.domain([0, _(lifeflowData).reduce(
        function (memo, node) {
          return Math.max(memo, node.y() + node.dy())
        }, 0)]);

      enterNodes();

      function xPos(lfnode) {
        return x(lfnode.x() + lfnode.depth * eventNodeWidth
          + alignmentLineWidth);
      }

      function enterNodes() {
        var enteringGs = nodes.enter()
          .append('g')
          .attr('class', 'event-node')
          .attr('depth', function (d) {
            return d.depth
          })
          .attr('path', function (d) {
            return d.namePath({noRoot: false}); // don't need noRoot anymore
          })
          .attr('transform', function (d) {
            return 'translate(' + xPos(d) + ',' + y(d.y()) + ')'
          });

        var newRects = enteringGs
          .append('rect')
          .attr('class', 'event-node')
          .attr('fill', function (d) {
            return color(d.valueOf())
          })
          .attr('width', eventNodeWidth)
          .attr('height', function (d) {
            return y(d.dy())
          })
          .attr('height', function (d) {
            return y(d.dy())
          })
          .on("mouseover", function (d, i) {
            dispatch.lifeflowMouseover(chart, this, d, i);
          })
          .on("mouseout", function (d, i) {
            dispatch.lifeflowMouseout(chart, this, d, i);
          })
      }
    });

    return chart;
  }

  //============================================================
  // Expose Public Variables
  //------------------------------------------------------------
  chart.dispatch = dispatch;

  chart.margin = function (_) {
    if (!arguments.length) return margin;
    margin.top = typeof _.top != 'undefined' ? _.top : margin.top;
    margin.right = typeof _.right != 'undefined' ? _.right : margin.right;
    margin.bottom = typeof _.bottom != 'undefined' ? _.bottom : margin.bottom;
    margin.left = typeof _.left != 'undefined' ? _.left : margin.left;
    return chart;
  };

  chart.eventNames = function (_) {
    if (!arguments.length) return eventNames;
    eventNames = _;
    return chart;
  };

  chart.timelineData = function (_) {
    if (!arguments.length) return timelineData;
    timelineData = _;
    return chart;
  };

  chart.width = function (_) {
    if (!arguments.length) return width;
    width = _;
    return chart;
  };

  chart.height = function (_) {
    if (!arguments.length) return height;
    height = _;
    return chart;
  };

  chart.xScale = function (_) {
    if (!arguments.length) return x;
    x = _;
    return chart;
  };

  chart.relativeX = function (_) {
    if (!arguments.length) return relativeX;
    relativeX = _;
    return chart;
  };

  chart.yScale = function (_) {
    if (!arguments.length) return y;
    y = _;
    return chart;
  };

  chart.color = function (_) {
    if (!arguments.length) return color;
    //color = nv.utils.getColor(_);
    color = _;
    return chart;
  };

  chart.id = function (_) {
    if (!arguments.length) return id;
    id = _;
    return chart;
  };

  chart.alignBy = function (_) {
    if (!arguments.length) return alignBy;
    alignBy = _;
    return chart;
  };

  chart.xAxis = function (_) {
    if (!arguments.length) return xAxis;
    xAxis = _;
    return chart;
  };

  chart.lifeflowData = function (_) {
    if (!arguments.length) return lifeflowData;
    lifeflowData = _;
    return chart;
  };

  chart.alignChoices = function (_) {
    if (!arguments.length) return alignChoices;
    alignChoices = _;
    return chart;
  };

  chart.eventNodeWidth = function (_) {
    if (!arguments.length) return eventNodeWidth;
    eventNodeWidth = _;
    return chart;
  };

  return chart;
};