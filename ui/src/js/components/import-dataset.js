var React = require('react');
var Dropzone = require('dropzone');

var ImportDataset = React.createClass({

  componentDidMount: function () {
    var dz1 = new Dropzone(this.refs.dropzone1.getDOMNode(), {maxFilesize: 1});
    /* first attempt at sending only up to the first 200K of a file as a sample
    dz1.on('sending', function (file, xhr, formData) {
      var fn = file.slice ? 'slice' : (file.mozSlice ? 'mozSlice' : (file.webkitSlice ? 'webkitSlice' : null));
      if (file != null) {
        var blob = file[fn](0, Math.min(200000, file.size));
        for (var i = 0; i < this.files.length; i++) {
          if (file.name === this.files[i].name) {
            this.files[i] = blob;
            formData.append(this._getParamName(i), blob, this.files[i].name)
            break;
          }
        }
      }
    });*/

    new Dropzone(this.refs.dropzone2.getDOMNode(), {maxFilesize: 1});

    new Dropzone(this.refs.dropzone3.getDOMNode(), {maxFilesize: 1});
  },

  render: function () {
    return (
      <div>
        <h1>Extract Metadata from Sample Delimited or JSON File</h1>
        <form ref="dropzone1" action="/api/upload" className="dropzone"></form>
        <br/>
        <h1>Extract Metadata from Sample Multi-recordset File</h1>
        <form ref="dropzone2" action="/api/upload/multi-recordset" className="dropzone"></form>
        <h1>Update Table Dataset Definitions</h1>
        <form ref="dropzone3" action="/api/upload/template" className="dropzone"></form>
      </div>
    );
  }
});

module.exports = ImportDataset;