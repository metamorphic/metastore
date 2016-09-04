var Fluxy = require('fluxy');
var AppConstants = require('../constants/app-constants');
var AppService = require('../services/app-service');

var AppActions = Fluxy.createActions({

  serviceActions: {

    uploadXdJob: [AppConstants.UPLOAD_XD_JOB, function (name, makeUnique, file) {
      return AppService.uploadXdJob(name, makeUnique, file);
    }],

    getStreamNamespaces: [AppConstants.GET_STREAM_NAMESPACES, function () {
      return AppService.getStreamNamespaces();
    }],

    searchEntities: [AppConstants.SEARCH_ENTITIES, function (q) {
      return AppService.searchEntities(q);
    }]
  }
});

module.exports = AppActions;