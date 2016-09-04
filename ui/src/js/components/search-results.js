var React = require('react');
var Hit = require('./hit');

var SearchResults = React.createClass({

  render: function () {
    var hits = this.props.hits;
    var visible = ('visible' in this.props) ? this.props.visible : true;
    return (
      <div className="list-group" style={{display: visible ? 'block' : 'none'}}>
        {hits.length ? hits.map(function (hit) {
          return (
            <Hit value={hit}/>
          )
        }): (<h4 className="no-result">No result found</h4>)}
      </div>
    );
  }
});

module.exports = SearchResults;