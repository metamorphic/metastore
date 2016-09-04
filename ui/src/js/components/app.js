var React = require('react');
var Router = require('react-router-component');
var Layout = require('./layout');
var Fluxy = require('fluxy');
var Metagrid = require('./metagrid');
var FileDatasets = require('./file-datasets');
var TableDatasets = require('./table-datasets');
var TableColumns = require('./table-columns');
var ImportDataset = require('./import-dataset');
var UpdateColumnNames = require('./update-column-names');
var Home = require('./home');
var Statistics = require('./statistics');
var SQLQuery = require('./sql-query');
var Help = require('./help');
var Documentation = require('./documentation');
var EventWizard = require('./event_wizard/event-wizard');
var TimelineVisualization = require('./visualizations/timeline-visualization2');
var SankeyVisualization = require('./visualizations/sankey-visualization');
var TreeVisualization = require('./visualizations/tree-visualization');
var LifeflowViz = require('./visualizations/lifeflow-viz');
var ManageSpringXd = require('./manage-spring-xd');
var ManageEventLog = require('./manage-event-log');
var AppStore = require('../stores/app-store');
var EntityInspector = require('metaform').EntityInspector;

var Locations = Router.Locations;
var Location = Router.Location;

Fluxy.start();

// <Location path={/\/grid\/(\w+)\/(\w+)\/(.+)/} matchKeys={['name', filter', 'filterParam']} handler={TestGrid}/>

var App = React.createClass({
  render: function () {
    return (
      <Layout>
        <Locations>
          <Location path="/grid/file-dataset" handler={FileDatasets}/>
          <Location path="/grid/table-dataset" handler={TableDatasets}/>
          <Location path="/grid/table-column/:parentName/:filter/:filterParam" handler={TableColumns}/>
          <Location path="/grid/:name/:parentName/:parentType/:parentId/:childProperty" handler={Metagrid}/>
          <Location path="/grid/:name/:parentName/:filter/:filterParam" handler={Metagrid}/>
          <Location path="/grid/:name" handler={Metagrid}/>
          <Location path="/datasets/import" handler={ImportDataset}/>
          <Location path="/update-column-names" handler={UpdateColumnNames}/>
          <Location path="/" handler={Home}/>
          <Location path="/stats" handler={Statistics}/>
          <Location path="/query" handler={SQLQuery}/>
          <Location path="/docs" handler={Help}/>
          <Location path="/docs/page/1" handler={Documentation}/>
          <Location path="/event-wizard" handler={EventWizard}/>
          <Location path="/viz/timeline" handler={TimelineVisualization}/>
          <Location path="/viz/flow" handler={SankeyVisualization}/>
          <Location path="/viz/tree" handler={TreeVisualization}/>
          <Location path="/viz/lifeflow" handler={LifeflowViz}/>
          <Location path="/manage-spring-xd" handler={ManageSpringXd}/>
          <Location path="/manage-event-log" handler={ManageEventLog}/>
          <Location path="/view/:type/:id" handler={EntityInspector}/>
        </Locations>
      </Layout>
    );
  }
});

module.exports = App;