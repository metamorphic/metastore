/**
 * Created by markmo on 3/05/15.
 */
var React = require('react');
var request = require('superagent');
var Form = require('metaform').Form;
var AppActions = require('metaform').AppActions;

var UpdateColumnNames = React.createClass({

  onPreSubmit: function (obj) {
    var datasetId = /\/(\d+)$/.exec(obj.dataset)[1];
    var data = {
      datasetId: datasetId,
      delimiter: obj.delimiter,
      names: obj.names
    };
    request.post('/api/headers')
      .send(data)
      .end(function (err, res) {
        if (err) {
          AppActions.alert(JSON.parse(res.text));
        } else {
          AppActions.alert({message: res.text});
        }
      });

    return false;
  },

  render: function () {
    return (
      <Form name="column-names" formType="vertical"
            onPreSubmit={this.onPreSubmit}/>
    );
  }
});

module.exports = UpdateColumnNames;