/**
 * Created by markmo on 4/05/15.
 */
var React = require('react');
var request = require('superagent');
var Form = require('metaform').Form;
var AppActions = require('metaform').AppActions;
var fuelux = require('fuelux');
window.$ = window.jQuery = require('jquery');

var EventWizard = React.createClass({

  getInitialState: function () {
    return {
      step: 1,
      eventTypeId: null,
      datasetId: null,
      filenamePattern: null,
      state: 'simple'
    };
  },

  componentDidMount: function () {
    var self = this;
    $(this.refs.eventwizard.getDOMNode()).on('actionclicked.fu.wizard', function (evt, data) {
      var nextStep = data.direction === 'next' ? data.step + 1 : data.step - 1;
      if (nextStep === 5 && self.state.datasetId) {
        request.get('/api/file-datasets/' + self.state.datasetId + '/file-data-source/filepath')
          .end(function (res) {
            if (self.isMounted()) {
              if (res.ok) {
                self.setState({filenamePattern: res.text});
              } else {
                AppActions.alert(JSON.parse(res.text));
              }
            }
          });
      }
      self.setState({step: nextStep});

    }).on('stepclicked.fu.wizard', function (evt, data) {
        self.setState({step: data.step});

    }).on('changed.fu.wizard', function (evt, data) {
      setTimeout(function () {
        if (self.state.state === 'advanced') {
          self.advanced();
        } else {
          self.simple();
        }
        if ($('.form-group.advanced').length) {
          $(self.refs.stateBtn.getDOMNode()).toggleClass('disabled', false);
        } else {
          $(self.refs.stateBtn.getDOMNode()).toggleClass('disabled', true);
        }
      },250);
    });

    $(this.refs.stateBtn.getDOMNode()).on('click', function () {
      if ($('.form-group.advanced').length) {
        $(this).button('toggle');
        if ($('.form-group.advanced.hidden').length) {
          self.advanced();
          self.setState({state: 'advanced'});
        } else {
          self.simple();
          self.setState({state: 'simple'});
        }
      }
    });
  },

  advanced: function () {
    var $advancedFormGroups = $('.form-group.advanced');
    if ($advancedFormGroups.length) {
      $(this.refs.stateBtn.getDOMNode()).button('advanced');
      $advancedFormGroups.toggleClass('hidden', false);
    }
  },

  simple: function () {
    var $advancedFormGroups = $('.form-group.advanced');
    if ($advancedFormGroups.length) {
      $(this.refs.stateBtn.getDOMNode()).button('reset');
      $advancedFormGroups.toggleClass('hidden', true);
    }
  },

  onPreSubmit: function (obj) {
    var self = this;
    if (this.state.step === 2) {
      var datasetId = /\/(\d+)$/.exec(obj.dataset)[1];
      request.post('/api/event-types/wizard')
        .send(obj)
        .end(function (err, res) {
          if (err) {
            //AppActions.alert({message: 'Error defining new event'});
            AppActions.alert(JSON.parse(res.text));
          } else {
            self.setState({eventTypeId: res.text, datasetId: datasetId});
            AppActions.alert({message: "Successfully created event '" + obj.name + "'"});
            $(self.refs.eventwizard.getDOMNode()).wizard('next');
          }
        });
    } else if (this.state.step === 3) {
      request.post('/api/event-types/' + this.state.eventTypeId + '/wizard/customer-id')
        .send(obj)
        .end(function (err, res) {
          if (err) {
            AppActions.alert(JSON.parse(res.text));
          } else {
            AppActions.alert({message: 'Successfully mapped customer ID to event'});
            $(self.refs.eventwizard.getDOMNode()).wizard('next');
          }
        });
    } else if (this.state.step === 4) {
      request.post('/api/event-types/' + this.state.eventTypeId + '/wizard/filter')
        .send(obj)
        .end(function (err, res) {
          if (err) {
            AppActions.alert(JSON.parse(res.text));
          } else {
            AppActions.alert({message: 'Successfully set filter rule on event'});
            $(self.refs.eventwizard.getDOMNode()).wizard('next');
          }
        });
    } else if (this.state.step === 5) {
      request.post('/api/event-types/' + this.state.eventTypeId + '/wizard/timestamp')
        .send(obj)
        .end(function (err, res) {
          if (err) {
            AppActions.alert(JSON.parse(res.text));
          } else {
            AppActions.alert({message: 'Successfully mapped timestamp to event'});
            $(self.refs.eventwizard.getDOMNode()).wizard('next');
          }
        });
    } else if (this.state.step === 6) {
      request.post('/api/file-datasets/' + this.state.datasetId + '/wizard/filename-pattern')
        .send(obj)
        .end(function (err, res) {
          if (err) {
            AppActions.alert(JSON.parse(res.text));
          } else {
            AppActions.alert({message: 'Successfully set filename pattern attached to event'});
            $(self.refs.eventwizard.getDOMNode()).wizard('next');
          }
        });
    }

    return false;
  },

  getStarted: function () {
    $(this.refs.eventwizard.getDOMNode()).wizard('next');
  },

  render: function () {
    return (
      <div className="wizard" data-initialize="wizard" ref="eventwizard">
        <ul className="steps">
          <li data-step="1" data-name="intro" className="active"><span className="badge">1</span>Intro<span className="chevron"></span></li>
          <li data-step="2" data-name="dataset" className="active"><span className="badge">2</span>Dataset<span className="chevron"></span></li>
          <li data-step="3" data-name="customer-id"><span className="badge">3</span>Customer ID<span className="chevron"></span></li>
          <li data-step="4" data-name="filter"><span className="badge">4</span>Filter Rule<span className="chevron"></span></li>
          <li data-step="5" data-name="timestamp"><span className="badge">5</span>Timestamp<span className="chevron"></span></li>
          <li data-step="6" data-name="filename-pattern"><span className="badge">6</span>Filename Pattern<span className="chevron"></span></li>
        </ul>
        <div className="actions">
          <button type="button" className="btn btn-default btn-prev"><span className="glyphicon glyphicon-arrow-left"></span>Prev</button>
          <button type="button" className="btn btn-default btn-next" data-last="Complete">Next<span className="glyphicon glyphicon-arrow-right"></span></button>
        </div>
        <div className="step-content">
          <div style={{marginBottom: '10px', paddingRight: '5px'}}>
            <button type="button" ref="stateBtn" data-advanced-text="Simple"
                    className="btn btn-default btn-sm disabled pull-right" autoComplete="off">Advanced</button>
          </div>
          <div className="step-pane active sample-pane alert" data-step="1" ref="step-pane-1">
            <div className="clearfix">
              <div className="pull-left" style={{marginRight: '20px'}}><img src="/assets/define_new_event.svg"/></div>
              <div>
                <p><br/></p>
                <p>
                  Defining a new event involves mapping columns from a dataset to the properties of the event.
                </p>
                <p>
                  Multiple events may be defined from a single dataset. Also, rows may be filtered so that only
                  rows that meet a given criteria are appended to the event log.
                </p>
                <div style={{textAlign: 'center'}}>
                  <button type="button" className="btn btn-default" onClick={this.getStarted}>Get started</button>
                </div>
              </div>
            </div>
          </div>
          <div className="step-pane active sample-pane alert" data-step="2" ref="step-pane-2">
            {this.state.step === 2 ?
              <Form name="event-wizard-dataset" formType="vertical"
                    onPreSubmit={this.onPreSubmit}/>
              : null
            }
          </div>
          <div className="step-pane sample-pane alert" data-step="3" ref="step-pane-3">
            {this.state.step === 3 ?
              <Form name="event-wizard-customer-id" formType="vertical"
                    onPreSubmit={this.onPreSubmit}/>
              : null
            }
          </div>
          <div className="step-pane sample-pane alert" data-step="4" ref="step-pane-4">
            {this.state.step === 4 ?
              <Form name="event-wizard-filter" formType="vertical"
                    onPreSubmit={this.onPreSubmit}/>
              : null
            }
          </div>
          <div className="step-pane sample-pane alert" data-step="5" ref="step-pane-5">
            {this.state.step === 5 ?
              <Form name="event-wizard-timestamp" formType="vertical"
                    onPreSubmit={this.onPreSubmit}/>
              : null
            }
          </div>
          <div className="step-pane sample-pane alert" data-step="6" ref="step-pane-6">
            {this.state.step === 6 ?
              <Form name="event-wizard-filename-pattern" formType="vertical"
                    onPreSubmit={this.onPreSubmit} value={{filenamePattern: this.state.filenamePattern}}/>
              : null
            }
          </div>
        </div>
      </div>
    );
  }
});

module.exports = EventWizard;