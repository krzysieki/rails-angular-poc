'use strict';

angular.module('translateProviderMock', [])
    .factory('$translateStaticFilesLoader', function ($q) {
        return function () {
            var deferred = $q.defer();
            deferred.resolve({});
            return deferred.promise;
        };
    })
    .factory('$translateFilter ', function ($q) {
        return function () {
            var deferred = $q.defer();
            deferred.resolve({});
            return deferred.promise;
        };
    });