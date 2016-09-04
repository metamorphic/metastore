var React = require('react');
var Link = require('react-router-component').Link;
var StringHelper = require('metaform').StringHelper;
var pluralize = require('pluralize');
var Truncated = require('metaform').Truncated;

var Hit = React.createClass({

  render: function () {
    var value = this.props.value;
    var type = StringHelper.readable(value.type);
    var parts = value.id.split(':');
    var resource = pluralize(StringHelper.dasherize(value.type));
    var url = '/view/' + resource + '/' + parts[1];
    return (
      <Link href={url} className="list-group-item">
        <span className="label label-default">{type}</span>
        <h4>{value.name}</h4>
        <div className="list-group-item-text">
          {value.description}
        </div>
      </Link>
    );
  }
});
// can't have an anchor within an anchor
/*
<div className="list-group-item-text">
  <Truncated text={value.description}/>
</div>
*/

module.exports = Hit;