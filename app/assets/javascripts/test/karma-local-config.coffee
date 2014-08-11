# Karma configuration
# Generated on Mon Mar 31 2014 11:54:11 GMT+0200 (CEST)

module.exports = (config) ->
  config.set


    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '..'


    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine']


    # list of files / patterns to load in the browser
    files: [
      './bower_components/jquery/dist/jquery.js'
      './bower_components/angular/angular.js'
      './bower_components/angular-ui-router/release/angular-ui-router.js'
      './bower_components/angular-translate/angular-translate.js'
      './bower_components/angular-translate-loader-static-files/angular-translate-loader-static-files.min.js'
      './bower_components/angular-mocks/angular-mocks.js'
      './test/unit/mocks/angular-translate.js'
      './.tmp/vendor.js'
      './.tmp/app.js'
      './.tmp/templates.js'
      './.tmp/xs-components-templates.js'
      '**/test/unit/**/*.coffee'
      'xs-components/**/*Test.coffee'
    ]


    # list of files to exclude
    exclude: [

    ]


    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors:
      '**/*.coffee': 'coffee'


    coffeePreprocessor:
      options:
        bare: true
        sourceMap: false

      transformPath: (path) ->
        path.replace(/\.coffee$/, '.js')


    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress']


    # web server port
    port: 9876


    # enable / disable colors in the output (reporters and logs)
    colors: true


    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO


    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true


    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome']


    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false
