var React = require('react');
var M = require('metaform');
var ModalForm = M.ModalForm;
var StringHelper = M.StringHelper;
var bootstrap = require('bootstrap');
window.$ = window.jQuery = require('jquery');

var Metaform = React.createClass({

  getInitialState: function () {
    return {
      title: 'Edit ' + StringHelper.readable(this.props.name)
    };
  },

  render: function () {
    return (
      <div>
        <button type="button" className="btn btn-primary btn-lg" data-toggle="modal" data-target="#modal1">Open Modal</button>
        <ModalForm ref="modal1" title={this.state.title} name={this.props.name}/>
      </div>
    );
  }
});

module.exports = Metaform;