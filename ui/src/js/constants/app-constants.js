var Fluxy = require('fluxy');

var AppConstants = Fluxy.createConstants({
  serviceMessages: [
    'UPLOAD_XD_JOB',
    'GET_STREAM_NAMESPACES',
    'SEARCH_ENTITIES'
  ]
});

module.exports = AppConstants;