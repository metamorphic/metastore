var React = require('react');
var Header = require('./header/header');
var Link = require('react-router-component').Link;
var Dropzone = require('dropzone');
var Modal = require('metaform').Modal;
var FileForm = require('./file-form');
window.$ = window.jQuery = require('jquery');

var Template = React.createClass({

  componentDidMount: function () {
    var self = this;
    new mlPushMenu(document.getElementById('mp-menu'), document.getElementById('trigger'));
    Dropzone.autoDiscover = false;
    var viewportElem = this.refs.viewport.getDOMNode();
    var previewElem = this.refs.dzPreviewContainer.getDOMNode();
    var dz = new Dropzone(viewportElem, {
      url: '/api/upload',
      previewsContainer: previewElem,
      maxFilesize: 1,
      clickable: false
    });
    dz.on('success', function (file, response, e) {
      self.showForm(file.name, response);
    }).on('complete', function () {
      setTimeout(function () {$(previewElem).hide('slow', function () {$(this).empty();$(this).show();})},5000);
    });
    //setTimeout(function () {viewportElem.className += ' dropzone';},0);
  },

  showForm: function (filename, response) {
    var container = document.getElementById('modals');
    var form = (
      <Modal id="modal1" title="Detected File Properties">
        <FileForm filename={filename} value={response} onImport={this.handleImport}/>
      </Modal>
    );
    React.render(form, container);
    $('#modal1').on('hidden.bs.modal', function () {
      React.unmountComponentAtNode(container);
    }).modal('show');
  },

  handleImport: function () {
    $('#modal1').modal('hide');
  },

  render: function () {
    return (
      <div className="mp-pusher" id="mp-pusher">
        <nav id="mp-menu" className="mp-menu">
          <div className="mp-level">
            <div className="brand pull-left"><img src="/assets/purple-m-logo-140x140.png" title="Metastore" alt="Metastore"/></div>
            <h2 className="icon icon-logo">Metastore</h2>
            <ul>
              <li>
                <Link className="icon fa-home" href="/">
                  Home
                </Link>
              </li>
              <li className="icon-li icon-arrow-left">
                <a className="icon fa-database" href="#">Data</a>
                <div className="mp-level">
                  <h2 className="icon fa-database">Data</h2>
                  <ul>
                    <li>
                      <Link className="icon fa-file-o" href="/grid/file-data-source">
                        File Sources
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-file-text-o" href="/grid/file-dataset">
                        File Datasets
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-database" href="/grid/table-data-source">
                        Table Sources
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-table" href="/grid/table-dataset">
                        Table Datasets
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-magic" href="/grid/transformation">
                        Transformations
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-upload" href="/datasets/import">
                        Extract metadata
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-pencil" href="/update-column-names">
                        Update column names
                      </Link>
                    </li>
                  </ul>
                </div>
              </li>
              <li className="icon-li icon-arrow-left">
                <a className="icon fa-bolt" href="#">Events</a>
                <div className="mp-level">
                  <h2 className="icon icon-bolt">Events</h2>
                  <ul>
                    <li>
                      <Link className="icon fa-bolt" href="/grid/event-type">
                        Event types
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-list" href="/grid/event-property-type">
                        Event property types
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-bullseye" href="/grid/customer-id-type">
                        Customer ID types
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-street-view" href="/grid/customer-id-mapping-rule">
                        ID mapping rules
                      </Link>
                    </li>
                  </ul>
                </div>
              </li>
              <li className="icon-li icon-arrow-left">
                <a className="icon fa-diamond" href="#">Feature Store</a>
                <div className="mp-level">
                  <h2 className="icon fa-diamond">Feature Store</h2>
                  <ul>
                    <li>
                      <Link className="icon fa-inbox" href="/grid/feature-family">
                        Feature Families
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-diamond" href="/grid/feature-type">
                        Feature types
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-check-square-o" href="/grid/feature-test">
                        Feature Unit Tests
                      </Link>
                    </li>
                  </ul>
                </div>
              </li>
              <li className="icon-li icon-arrow-left">
                <a className="icon fa-cubes" href="#">Analytical Model Registry</a>
                <div className="mp-level">
                  <h2 className="icon fa-cubes">Analytical Model Registry</h2>
                  <ul>
                    <li>
                      <Link className="icon fa-cube" href="/grid/model">
                        Analytical Models
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-battery-full" href="/grid/model-package">
                        Model Packages
                      </Link>
                    </li>
                  </ul>
                </div>
              </li>
              <li className="icon-li icon-arrow-left">
                <a className="icon fa-wrench" href="#">Tools</a>
                <div className="mp-level">
                  <h2 className="icon fa-wrench">Tools</h2>
                  <ul>
                    <li>
                      <Link className="icon fa-rocket" href="/grid/job">
                        Jobs
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-send" href="/grid/test-job">
                        Test Jobs
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-bar-chart" href="/stats">
                        Stats
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-book" href="/docs">
                        Help
                      </Link>
                    </li>
                  </ul>
                </div>
              </li>
              <li className="icon-li icon-arrow-left">
                <a className="icon fa-cog" href="#">Configuration</a>
                <div className="mp-level">
                  <h2 className="icon fa-cog">Configuration</h2>
                  <ul>
                    <li className="icon-li icon-arrow-left">
                      <a className="icon fa-leaf" href="#">Spring XD</a>
                      <div className="mp-level">
                        <h2 className="icon fa-leaf">Spring XD</h2>
                        <ul>
                          <li>
                            <Link className="icon fa-plug" href="/grid/stream">
                              Define Streams
                            </Link>
                          </li>
                          <li>
                            <Link className="icon fa-play" href="/manage-spring-xd">
                              Deploy
                            </Link>
                          </li>
                        </ul>
                      </div>
                    </li>
                    <li className="icon-li icon-arrow-left">
                      <a className="icon fa-tags" href="#">Reference Types</a>
                      <div className="mp-level">
                        <h2 className="icon fa-tags">Reference Types</h2>
                        <ul>
                          <li>
                            <Link className="icon fa-th" href="/grid/data-type">
                              Data types
                            </Link>
                          </li>
                          <li>
                            <Link className="icon fa-language" href="/grid/value-type">
                              Value types
                            </Link>
                          </li>
                          <li>
                            <Link className="icon fa-user-secret" href="/grid/security-classification">
                              Security classifications
                            </Link>
                          </li>
                        </ul>
                      </div>
                    </li>
                    <li>
                      <Link className="icon fa-refresh" href="/manage-event-log">
                        Manage Event Log
                      </Link>
                    </li>
                    <li>
                      <Link className="icon-li icon-params" href="/grid/setting">
                        Settings
                      </Link>
                    </li>
                    <li>
                      <Link className="icon fa-list-alt" href="/grid/form-schema">
                        Form Schemas
                      </Link>
                    </li>
                  </ul>
                </div>
              </li>
            </ul>
          </div>
        </nav>
        <div className="scroller dropzone" ref="viewport" id="viewport">
          <div className="scroller-inner">
            <Header/>
            <a href="#" id="trigger" className="menu-trigger">Metastore</a>
            <div className="dropzone-previews" ref="dzPreviewContainer"/>
            <div className="content">{this.props.children}</div>
          </div>
        </div>
      </div>
    );
  }
});
/*
<nav id="mp-menu" className="mp-menu">
  <div className="mp-level">
    <div className="brand pull-left"><img src="/assets/metamorphic_logo.png" title="Metastore" alt="Metastore"/></div>
    <h2 className="icon icon-logo">Metastore</h2>
    <ul>
      <li>
        <Link className="icon fa-home" href="/">
          Home
        </Link>
      </li>
      <li className="icon-li icon-arrow-left">
        <a className="icon fa-database" href="#">Data</a>
        <div className="mp-level">
          <h2 className="icon fa-database">Data</h2>
          <ul>
            <li>
              <Link className="icon fa-file-o" href="/grid/file-data-source">
                File Sources
              </Link>
            </li>
            <li>
              <Link className="icon fa-file-text-o" href="/grid/file-dataset">
                File Datasets
              </Link>
            </li>
            <li>
              <Link className="icon fa-database" href="/grid/table-data-source">
                Table Sources
              </Link>
            </li>
            <li>
              <Link className="icon fa-table" href="/grid/table-dataset">
                Table Datasets
              </Link>
            </li>
            <li>
              <Link className="icon fa-upload" href="/datasets/import">
                Extract metadata
              </Link>
            </li>
            <li>
              <Link className="icon fa-pencil" href="/update-column-names">
                Update column names
              </Link>
            </li>
          </ul>
        </div>
      </li>
      <li className="icon-li icon-arrow-left">
        <a className="icon fa-bolt" href="#">Events</a>
        <div className="mp-level">
          <h2 className="icon icon-bolt">Events</h2>
          <ul>
            <li>
              <Link className="icon fa-bolt" href="/grid/event-type">
                Event types
              </Link>
            </li>
            <li>
              <Link className="icon fa-list" href="/grid/event-property-type">
                Event property types
              </Link>
            </li>
            <li>
              <Link className="icon fa-bullseye" href="/grid/customer-id-type">
                Customer ID types
              </Link>
            </li>
            <li>
              <Link className="icon fa-street-view" href="/grid/customer-id-mapping-rule">
                ID mapping rules
              </Link>
            </li>
          </ul>
        </div>
      </li>
      <li className="icon-li icon-arrow-left">
        <a className="icon fa-diamond" href="#">Features</a>
        <div className="mp-level">
          <h2 className="icon fa-diamond">Features</h2>
          <ul>
            <li>
              <Link className="icon fa-user" href="/grid/customer-property-type">
                Customer property types
              </Link>
            </li>
            <li>
              <Link className="icon fa-diamond" href="/grid/event-type">
                Feature types
              </Link>
            </li>
          </ul>
        </div>
      </li>
      <li className="icon-li icon-arrow-left">
        <a className="icon fa-cube" href="#">Visualisations</a>
        <div className="mp-level">
          <h2 className="icon fa-cube">Visualisations</h2>
          <ul>
            <li>
              <Link className="icon fa-barcode" href="/viz/timeline">
                Timeline
              </Link>
            </li>
            <li>
              <Link className="icon fa-sign-out" href="/viz/flow">
                Event Flow
              </Link>
            </li>
            <li>
              <Link className="icon fa-pagelines" href="/viz/tree">
                Next Event Pathways
              </Link>
            </li>
            <li>
              <Link className="icon fa-chain" href="/viz/lifeflow">
                Lifeflow
              </Link>
            </li>
          </ul>
        </div>
      </li>
      <li className="icon-li icon-arrow-left">
        <a className="icon fa-cogs" href="#">Tools</a>
        <div className="mp-level">
          <h2 className="icon fa-cogs">Tools</h2>
          <ul>
            <li>
              <Link className="icon fa-question-circle" href="/query">
                Query
              </Link>
            </li>
            <li>
              <Link className="icon fa-cogs" href="/grid/job">
                Jobs
              </Link>
            </li>
            <li>
              <Link className="icon fa-bar-chart" href="/stats">
                Stats
              </Link>
            </li>
            <li>
              <Link className="icon fa-book" href="/docs">
                Help
              </Link>
            </li>
          </ul>
        </div>
      </li>
      <li className="icon-li icon-arrow-left">
        <a className="icon-li icon-params" href="#">Configuration</a>
        <div className="mp-level">
          <h2 className="icon-li icon-params">Configuration</h2>
          <ul>
            <li>
              <Link className="icon fa-th" href="/grid/data-type">
                Data types
              </Link>
            </li>
            <li>
              <Link className="icon fa-language" href="/grid/value-type">
                Value types
              </Link>
            </li>
            <li>
              <Link className="icon fa-user-secret" href="/grid/security-classification">
                Security classifications
              </Link>
            </li>
            <li>
              <Link className="icon-li icon-params" href="/grid/setting">
                Settings
              </Link>
            </li>
            <li>
              <Link className="icon fa-cogs" href="/grid/xd-job">
                XD Jobs
              </Link>
            </li>
            <li>
              <Link className="icon fa-play" href="/grid/stream">
                Streams
              </Link>
            </li>
            <li>
              <Link className="icon fa-upload" href="/manage-spring-xd">
                Manage Spring XD
              </Link>
            </li>
            <li>
              <Link className="icon fa-list-alt" href="/grid/form-schema">
                Form schemas
              </Link>
            </li>
          </ul>
        </div>
      </li>
    </ul>
  </div>
</nav>
*/

module.exports = Template;