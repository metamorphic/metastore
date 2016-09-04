var React = require('react');
var AppActions = require('metaform').AppActions;
var Placard = require('metaform').Placard;
var serialize = require('form-serialize');
var request = require('superagent');
var fuelux = require('fuelux');

var FileForm = React.createClass({

  //componentDidMount: function () {
  //  $('.checkbox').checkbox();
  //},

  doImport: function () {
    if (this.props.value.fileType === 'DELIMITED') {
      var self = this;
      var form = this.refs.form1.getDOMNode();
      var data = serialize(form, {hash: true});
      data.header = !!(data.header);
      var $importBtn = $(this.refs.importBtn.getDOMNode())
        .button('importing');
      request.post('/api/file-datasets/' + this.props.filename + '/confirm-import')
        .send(data)
        .end(function (err, res) {
          if (res.ok) {
            AppActions.alert({message: res.text});
          } else {
            AppActions.alert(JSON.parse(res.text));
          }
          $importBtn.button('reset');
          self.props.onImport();
        });
    } else {
      this.props.onImport();
    }
  },

  render: function () {
    return (
      <form className="form-horizontal" ref="form1">
        <div className="form-group">
          <label className="col-sm-3 control-label">File Type</label>
          <div className="col-sm-9">
            <div className="form-control readonly">{this.props.value.fileType}</div>
          </div>
        </div>
        {this.props.value.fileType === 'DELIMITED' ? (
          <div>
            <Placard field="columnDelimiter" title="Column Delimiter" value={this.props.value.fileParameters.columnDelimiter}/>
            <Placard field="lineTerminator" title="Row Delimiter" value={this.props.value.fileParameters.lineTerminator}/>
            <Placard field="textQualifier" title="Quote character" value={this.props.value.fileParameters.textQualifier}/>
            <div className="form-group">
              <label className="col-sm-3 control-label" htmlFor="header"></label>
              <div className="col-sm-9">
                <div className="checkbox">
                  <label className="checkbox-custom" data-initialize="checkbox">
                    <input type="checkbox" id="header" name="header" defaultChecked={this.props.value.fileParameters.header} className="sr-only"/>
                    <span className="checkbox-label">Header?</span>
                  </label>
                </div>
              </div>
            </div>
          </div>) : null}
        <div className="form-group">
          <label className="col-sm-3 control-label">Columns</label>
          <div className="col-sm-9 import-columns">
            <table className="table table-hover table-condensed">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Name</th>
                  <th>Type</th>
                </tr>
              </thead>
              <tbody>
                {this.props.value.columns.map(function (c) {
                  return (
                    <tr>
                      <td>{c.columnIndex}</td>
                      <td>{c.name}</td>
                      <td>{c.type}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
        <div className="modal-footer">
          <button type="button" className="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" className="btn btn-primary" data-importing-text="Importing..." ref="importBtn"
                  onClick={this.doImport}>{this.props.value.fileType === 'DELIMITED' ? 'Do Import' : 'Done'}</button>
        </div>
      </form>
    );
  }
});

module.exports = FileForm;