var Promise = require('bluebird');
var request = require('superagent');

var url = '/api';

module.exports = {

  uploadXdJob: function (name, makeUnique, file) {
    return new Promise(function (resolve, reject) {
      request.post(url + '/xd-jobs/upload')
        .field('name', name)
        .field('makeUnique', makeUnique)
        .attach('file', file, file.name)
        .end(function (err, res) {
          if (err) {
            reject(err);
          } else {
            resolve(res.text);
          }
        });
    });
  },

  getStreamNamespaces: function () {
    return new Promise(function (resolve, reject) {
      request.get(url + '/stream-namespaces', function (err, res) {
        if (err) {
          reject(err);
        } else {
          resolve(JSON.parse(res.text));
        }
      });
    });
  },

  searchEntities: function (q) {
    return new Promise(function (resolve, reject) {
      request.get(url + '/entities/search/?q=' + q, function (err, res) {
        if (err) {
          reject(err);
        } else {
          var json = JSON.parse(res.text);
          if (json.page.totalElements) {
            resolve(json['_embedded'].entityDocuments);
          } else {
            resolve([]);
          }
        }
      });
    });
  }
};