var Fluxy = require('fluxy');
var AppConstants = require('../constants/app-constants');
var AppActions = require('metaform').AppActions;

var AppStore = Fluxy.createStore({

  getInitialState: function () {
    return {
      streamNamespaces: [],
      hits: []
    };
  },

  actions: [

    [AppConstants.UPLOAD_XD_JOB_COMPLETED, function () {
      AppActions.alert({message: 'XD Job has been uploaded'});
    }],

    [AppConstants.UPLOAD_XD_JOB_FAILED, function (err) {
      AppActions.alert({error: err, message: err});
    }],

    [AppConstants.GET_STREAM_NAMESPACES_COMPLETED, function (namespaces) {
      this.set('streamNamespaces', namespaces);
    }],

    [AppConstants.GET_STREAM_NAMESPACES_FAILED, function (err) {
      AppActions.alert({error: err, message: err});
    }],

    [AppConstants.SEARCH_ENTITIES_COMPLETED, function (hits) {
      this.set('hits', hits);
    }],

    [AppConstants.SEARCH_ENTITIES_FAILED, function (err) {
      AppActions.alert({error: err, message: err});
    }]
  ],

  getStreamNamespaces: function () {
    return this.getAsJS('streamNamespaces');
  },

  getSearchHits: function () {
    return this.getAsJS('hits');
  }
});

module.exports = AppStore;