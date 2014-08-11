exports.config = {
    seleniumAddress: 'http://localhost:4444/wd/hub',
    baseUrl: 'http://localhost:8004/',
    specs: ['../.tmp/uiTest.js'],
    capabilities: {
        'browserName': 'chrome'
    },
    onPrepare: function(){
        require('jasmine-reporters');
        var capsPromise = browser.getCapabilities();
        capsPromise.then(function(caps){
            var browserName = caps.caps_.browserName.toUpperCase();
            var browserVersion = caps.caps_.version;
            var prePendStr = browserName + "-" + browserVersion + "-";
            jasmine.getEnv().addReporter(new
                jasmine.JUnitXmlReporter(".tmp/protractor-output", true, true,prePendStr));
        })
    }
}