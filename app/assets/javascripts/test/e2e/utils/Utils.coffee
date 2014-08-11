class Utils

  setUp: ->
    width = 1280;
    height = 800;
    browser.driver.manage().window().setSize(width, height);

  tearDown: ->
    testName = jasmine.getEnv().currentSpec.description.replace(new RegExp(' ', 'g'), '-');
    browser.takeScreenshot().then (png) ->
      fs = require("fs")
      buf = new Buffer(png, "base64")
      stream = fs.createWriteStream(".tmp/tests-screens/" + testName + ".png")
      stream.write buf
      stream.end()

Utils = new Utils()