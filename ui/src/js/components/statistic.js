var React = require('react');
var numeral = require('numeral');

var Statistic = React.createClass({

  render: function () {
    return (
      <div className="col-md-2 col-md-offset-1 statistic">
        <div className="value">
          {this.props.numberFormat && !isNaN(this.props.value) ?
            numeral(this.props.value).format(this.props.numberFormat) : this.props.value}
        </div>
        <label>{this.props.label}</label>
      </div>
    );
  }
});

module.exports = Statistic;