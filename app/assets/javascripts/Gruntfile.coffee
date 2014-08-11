module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  pkg = grunt.file.readJSON('package.json')

  ## Grunt cmd line parameters
  testType = if grunt.option('type') then grunt.option('type') else 'full'
  testFile = if grunt.option('file') then grunt.option('file') else false

  commonTestFiles = [
    '**/test/e2e/utils/*.coffee'
    '**/test/e2e/components-objects/**/*.coffee'
    '**/test/e2e/page-objects/**/*.coffee'
  ]

  createTestFilesSet = (set) ->
    common = commonTestFiles.slice()
    common.concat(set)

  grunt.initConfig
    pkg: pkg

    options:
      verbose: true

    cfg:
      http:
        port: 8005 # http server port
        host: '*' # listen on all interfaces
        livereloadport: 35741 #livereload port
      tmp: '.tmp'
      public: 'public'
      dist: 'dist'
      coffeeFiles: [
        'app/app.coffee' # first app cofee
        'app/*.coffee'
        'app/*/*.coffee'
        'app/*/*/*.coffee'
        'app/*/*/*/*.coffee'
        'app/**/*.coffee'
      ]
      testUI_full: createTestFilesSet([
        'test/e2e/*UITest.coffee'
      ])

      testUI_deep: createTestFilesSet([
        'test/e2e/*UITest.coffee'
      ])

      testUI_smoke: createTestFilesSet([
        'test/e2e/*SmokeUITest.coffee'
      ])
      testUI_specificFile: createTestFilesSet([
        'test/e2e/' + testFile + '.coffee'
      ])

    # clean public directory
    clean:
      dist: ['<%= cfg.public %>']
      uiTest: ['<%= cfg.tmp %>/uiTest.js', '<%= cfg.tmp %>/uiTest-tmp.js' , '<%= cfg.tmp %>/tests-screens/*', '<%= cfg.tmp %>/protractor-output/*']
      dev: ['<%= cfg.tmp %>']

    # create directories for tasks (some of the tasks can't create dirs, slike spritepacker
    mkdir:
      all:
        options:
          create: ['<%= cfg.tmp %>', '<%= cfg.public %>', '<%= cfg.dist %>', '<%= cfg.tmp %>/images','<%= cfg.tmp %>/tests-screens', '<%= cfg.tmp %>/protractor-output']

    # compile coffee script files
    coffee:
      options:
        bare: true
        sourceMap: true
      compile:
        files:
          '<%= cfg.tmp %>/app.js': ['<%= cfg.coffeeFiles %>']

      uiTest_full:
        files:
          '<%= cfg.tmp %>/uiTest-tmp.js': "<%= cfg.testUI_full %>"
      uiTest_smoke:
        files:
          '<%= cfg.tmp %>/uiTest-tmp.js': "<%= cfg.testUI_smoke %>"
      uiTest_deep:
        files:
          '<%= cfg.tmp %>/uiTest-tmp.js': "<%= cfg.testUI_deep %>"
      uiTest_specificFile:
        files:
          '<%= cfg.tmp %>/uiTest-tmp.js': "<%= cfg.testUI_specificFile %>"
      unitTest:
        files:
          '<%= cfg.tmp %>/unitTest-tmp.js': ['**/test/unit/**/*.coffee', 'xs-components/**/*Test.coffee']

    jade:
      options:
        client: false
        pretty: true
      main:
        files: [
          src: 'app/index.jade'
          dest: '<%= cfg.tmp %>/index.html'
          expand: false
        ]
      views:
        files: [
          cwd: 'app'
          expand: true
          src: ['**/*.jade', '!index.jade']
          dest: '<%= cfg.tmp %>/templates/'
          ext: '.html'
        ]

    ngtemplates:
      app:
        cwd: '<%= cfg.tmp %>/templates/'
        src: '**/*.html'
        dest: '<%= cfg.tmp %>/templates.js'
        options:
          module: 'app'
          standalone: true
          prefix: 'app/'
          bootstrap: (module, script) ->
            'App = App || angular.module("'+ module + '"); App.run(["$templateCache", function($templateCache){' + script + '}]);'


    # copy assets into dist dir
    copy:
      assets:
        files: [
          expand: true
          cwd: 'app/assets'
          src: ['**', '!**/*.png', '!**/*.jpg', '!**/*.gif']
          dest: '<%= cfg.public %>'
        ]
      index:
        src: '<%= cfg.tmp %>/index.html'
        dest: '<%= cfg.public %>/index.html'

    spritepacker:
      icons:
        options:
          template: 'sprite/spritepacker.tpl'
          destCss: '<%= cfg.tmp %>/sprites.styl'
          baseUrl: ''
          padding: 5
        files:
          '<%= cfg.tmp %>/icons.png': ['sprite/icons/*.png']


    # concat all javascript/css files found in project into one per each type. Save them into temporary diractory, later will be minified
    concat:
      vendor:
        options:
          separator: ';\n'
        src: ['app/**/*.js', '!app/assets/**/*.js']
        dest: '<%= cfg.tmp %>/vendor.js'
      css:
        options:
          separator: '\n\n'
        src: ['app/**/*.css']
        dest: '<%= cfg.tmp %>/vendor.css'
      uiTest:
        src: ['app/sps-shared/test/e2e/utils/chance.js', '<%= cfg.tmp %>/uiTest-tmp.js']
        dest: '<%= cfg.tmp %>/uiTest.js'


    stylus:
      options:
        import: ['nib']
        paths: ['.tmp']
      compile:
        files:
          '<%= cfg.tmp %>/app.css': ['app/styles/index.styl', 'app/styles/**/*.styl', '!app/styles/**/_*.styl']
      spirtes:
        files:
          '<%= cfg.tmp %>/sprites.css': ['<%= cfg.tmp %>/sprites.styl']


    # process index file
    useminPrepare:
      html: '<%= cfg.tmp %>/index.html'
      options:
        dest: '<%= cfg.public %>'

    usemin:
      html: ['<%= cfg.public %>/index.html']


    uglify:
      app:
        files:
          '<%= cfg.public %>/vendor.js': ['<%= cfg.tmp %>/vendor.js']
          '<%= cfg.public %>/app.js': ['<%= cfg.tmp %>/app.js']

    notify_hooks:
      options:
        enabled: true
        max_jshint_notifications: 5
        title: 'Grunt'


    connect:
      options:
        port: '<%= cfg.http.port %>'
        hostname: '<%= cfg.http.host %>'
        livereload: '<%= cfg.http.livereloadport %>'
      livereload:
        options:
          open: true
          base: ['<%= cfg.tmp %>', 'bower_components', '.', '<%= cfg.public %>']
      public:
        options:
          base: '<%= cfg.public %>'


    concurrent:
      options:
        logConcurrentOutput: false

      # we do not have images at the moment
      # assets: ['imagemin', 'copy:assets']
      assets: ['copy:assets']
      compile: ['coffee:compile', 'stylus', 'jade']
      concat: ['concat:vendor', 'concat:css']


    imagemin:
      assets:
        files: [
          expand: true
          cwd: 'app/assets'
          src: ['**/*.{png,jpg,gif}']
          dest: '<%= cfg.public %>'
        ]
      genrated:
        files: [
          expand: true
          cwd: '<%= cfg.tmp %>'
          src: ['**/*.{png,jpg,gif}']
          dest: '<%= cfg.public %>'
        ]


    notify:
      buildstart:
        options:
          title: 'Build start'
          message: 'Build has been started'
      buildcomplete:
        options:
          title: 'Build complete'
          message: 'Build ready in public direcory'
      watchstyles:
        options:
          title: 'Styles'
          message: 'rebuild'
      watchjade:
        options:
          title: 'Jade'
          message: 'rebuild views'
      watchassets:
        options:
          title: 'Assets'
          message: 'copy'
      watchcoffee:
        options:
          title: 'Scripts'
          message: 'rebuild'
      serverstarted:
        options:
          title: 'Server'
          message: 'started'


    watch:
      options:
        spawn: false
        livereload: '<%= connect.options.livereload %>'
      coffee:
        files: ['app/**/*.coffee']
        tasks: ['coffee:compile', ]
      jademain:
        files: ['app/index.jade']
        tasks: ['jade:main', 'concat']
      jade:
        files: ['app/**/*.jade', '!app/index.jade']
        tasks: ['jade:views', 'ngtemplates:app']
      styles:
        files: ['app/**/*.styl']
        tasks: ['stylus', 'concat:css']
        options:
          nospawn: true
          livereload: false
      icons:
        files: ['sprite/**/*']
        tasks: ['spritepacker', 'concurrent:assets', 'concurrent:compile']
      assets:
        files: ['app/assets/*']
        tasks: ['copy:assets']
      livereload:
        options:
          livereload: '<%= connect.options.livereload %>'
        files: [
          '<%= cfg.tmp %>/**/.html',
          '<%= cfg.tmp %>/**/*.css',
          '<%= cfg.tmp %> /**/*.js'
          '<%= cfg.public %>/**/.html',
          '<%= cfg.public %>/**/*.css',
          '<%= cfg.public %> /**/*.js'
        ]


    protractor:
      ui:
        options:
          configFile: "test/protractor-local.config.js"
          keepAlive: false
          noColor: false
          args: {}

    karma:
      unit:
        configFile: 'test/karma-local-config.coffee'
        autoWatch: true

    bump:
      options:
        files: ['package.json', 'bower.json']
        updateConfigs: []
        commit: true
        commitMessage: 'Release %VERSION%'
        commitFiles: ['package.json', 'bower.json', 'dist/xs-components.js']
        createTag: true
        tagName: 'v%VERSION%'
        tagMessage: 'Version %VERSION%'
        push: true
        pushTo: 'ssh://source.int.xstream.dk:29418/dk.xstream.frontend.xs_components'
        gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d'

  grunt.task.run('notify_hooks')

  grunt.registerTask('build', [
    'notify:buildstart'
    'clean'
    'mkdir'
    'spritepacker'
    'concurrent:assets'
    'concurrent:compile'
    'ngtemplates'
    'concurrent:concat'
    'useminPrepare'
    'copy:index'
    'concat'
    'uglify'
    'cssmin'
    'usemin'
    'notify:buildcomplete'
  ])

  grunt.registerTask('release', [
    'notify:buildstart'
    'clean'
    'mkdir'
    'coffee:compile_bower'
    'jade:xsComponents'
    'ngtemplates:xsComponents'
    'uglify:xsComponents'
    'bump'
    'notify:buildcomplete'
  ])

  grunt.registerTask('test',

    if testType is 'unit'
      [
        'karma:unit'
      ]
    else
      [
        'clean:uiTest'
        'coffee:uiTest_' + (if testFile then 'specificFile' else testType)
        'concat:uiTest'
        'protractor:ui'
      ]
  )

  grunt.registerTask('unit', [
    'karma:unit'
  ])

  grunt.registerTask('jenkins-test', [
    'connect:livereload'
    'test'
  ])


  grunt.registerTask('server', [
    'notify:buildstart'
    'clean'
    'mkdir'
    'spritepacker'
    'concurrent:assets'
    'concurrent:compile'
    'concurrent:concat'
    'ngtemplates'
    'connect:livereload'
    'watch'
    'notify:serverstarted'
  ])

  grunt.registerTask('default', ->
    grunt.log.oklns('------------------------')
    grunt.log.oklns('Usage:')
    grunt.log.oklns('------------------------')
    grunt.log.oklns('$ grunt build')
    grunt.log.oklns('Builds application. Doesnt update submodules.')
    grunt.log.oklns('------------------------')
    grunt.log.oklns('$ grunt server')
    grunt.log.oklns('Application startup with livereload. It also triggers grunt build.')
    grunt.log.oklns('------------------------')
    grunt.log.oklns('$ grunt release')
    grunt.log.oklns('Build files required to prepare bower package - for use by external projects.')
    grunt.log.oklns('IMPORTANT: Version is bumped automatically.')
    grunt.log.oklns('IMPORTANT: Git tag is created automatically.')
    grunt.log.oklns('------------------------')
    grunt.log.oklns('$ grunt unit')
    grunt.log.oklns('Runs unit tests for application.')
    grunt.log.oklns('------------------------')
    grunt.log.oklns('$ grunt')
    grunt.log.oklns('Shows this help.')
    grunt.log.oklns('------------------------')
  )