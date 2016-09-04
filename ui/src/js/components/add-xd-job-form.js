var React = require('react');
var AppActions = require('../actions/app-actions');
window.$ = window.jQuery = require('jquery');

var AddXdJobForm = React.createClass({

  handleSubmit: function (event) {
    event.preventDefault();
    var name = this.refs.name.getDOMNode().value;
    var makeUnique = $(this.refs.makeUnique.getDOMNode()).is(':checked');
    var file = this.refs.jar.getDOMNode().files[0];
    var $submitBtn = $(this.refs.submitBtn.getDOMNode()).button('loading');
    AppActions.uploadXdJob(name, makeUnique, file).then(function () {
      $submitBtn.button('reset');
    });
  },

  render: function () {
    return (
      <form className="form-horizontal">
        <div className="form-group">
          <label htmlFor="name" className="col-sm-2 control-label">Name</label>
          <div className="col-sm-10">
            <input ref="name" type="text" className="form-control" id="name" placeholder="Name" autoComplete="off"/>
          </div>
        </div>
        <div className="form-group">
          <label htmlFor="jar" className="col-sm-2 control-label">JAR</label>
          <div className="col-sm-10">
            <input ref="jar" type="file" className="form-control" id="jar" placeholder="JAR file"/>
          </div>
        </div>
        <div className="form-group">
          <div className="col-sm-offset-2 col-sm-10">
            <div className="checkbox">
              <label className="checkbox-custom" data-initialize="checkbox">
                <input ref="makeUnique" type="checkbox" id="makeUnique" className="sr-only"/>
                <span className="checkbox-label">Make Unique?</span>
              </label>
            </div>
          </div>
        </div>
        <button ref="submitBtn" type="button" className="btn btn-default"
                onClick={this.handleSubmit} data-loading-text="Uploading..."
                autoComplete="off">Upload XD Job</button>
      </form>
    );
  }
});

module.exports = AddXdJobForm;