var React = require('react');
var Markdown2HTML = require('react-markdown-to-html');
var Link = require('react-router-component').Link;

var Documentation = React.createClass({

  render: function () {
    return (
      <div>
        <p><Link href="/docs">Index</Link></p>
        <Markdown2HTML src="/documentation.md"/>
        <p><Link href="/docs">Index</Link></p>
      </div>
    );
  }
});

module.exports = Documentation;