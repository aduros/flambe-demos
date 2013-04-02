#!/usr/bin/env python
#
# Runs Selenium integration tests via Sauce Labs. This assumes that the Flambe app is available at
# http://localhost:5000.

import base64
import httplib
import json
import new
import os
import random
import sys
import unittest

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait

class FlambeTest(unittest.TestCase):
    # Test classes are generated automagically further below
    __test__ = False

    def setUp (self):
        self.username = "flambe"
        self.key = os.environ["SAUCE_ACCESS_KEY"]

        self.caps["name"] = "Flambe Selenium"
        if os.environ.get("TRAVIS"):
            self.caps["tunnel-identifier"] = os.environ["TRAVIS_JOB_NUMBER"]
            self.caps["build"] = os.environ["TRAVIS_BUILD_NUMBER"]
            self.caps["tags"] = [os.environ["TRAVIS_BRANCH"]]

        # localhost:4445 gets tunneled over Sauce Connect
        hub_url = "http://%s:%s@localhost:4445/wd/hub" % (self.username, self.key)
        self.driver = webdriver.Remote(desired_capabilities=self.caps, command_executor=hub_url)

        self.job_id = self.driver.session_id
        print("Running job: https://saucelabs.com/jobs/%s" % self.job_id)
        self.driver.implicitly_wait(30)

    def test_sauce (self):
        # Open the app and wait for the canvas to show up
        self.driver.get("http://localhost:5000/index.html?flambe=html")
        self.driver.find_element_by_id("content-canvas")

        # Poll the app for the test status variable
        status = [None] # An array because closure scope in Python is whack
        def check_status (driver):
            status[0] = driver.execute_script("return window.$flambe_selenium_status")
            return status[0] != None
        WebDriverWait(self.driver, 30).until(check_status)

        # The status will be "OK", or the error message if something went wrong
        self.assertEquals(status[0], "OK")

    def tearDown (self):
        self.driver.quit()

        # Tell Sauce whether the test failed or passed
        auth = base64.encodestring("%s:%s" % (self.username, self.key))[:-1]
        result = json.dumps({"passed": sys.exc_info() == (None, None, None)})
        connection = httplib.HTTPConnection("saucelabs.com")
        connection.request("PUT", "/rest/v1/%s/jobs/%s" % (self.username, self.job_id),
                           result, headers={"Authorization": "Basic %s" % auth})
        self.assertEquals(connection.getresponse().status, 200)

PLATFORMS = [
    dict(webdriver.DesiredCapabilities.CHROME, platform="WINDOWS"),
    dict(webdriver.DesiredCapabilities.FIREFOX, platform="WINDOWS"),
    dict(webdriver.DesiredCapabilities.INTERNETEXPLORER, version="10", platform="WINDOWS"),
    dict(webdriver.DesiredCapabilities.INTERNETEXPLORER, version="9", platform="WINDOWS"),
    dict(webdriver.DesiredCapabilities.OPERA, platform="WINDOWS"),

    dict(webdriver.DesiredCapabilities.CHROME, platform="MAC"),
    dict(webdriver.DesiredCapabilities.FIREFOX, platform="MAC"),
    dict(webdriver.DesiredCapabilities.SAFARI, platform="MAC"),

    dict(webdriver.DesiredCapabilities.CHROME, platform="LINUX"),
    dict(webdriver.DesiredCapabilities.FIREFOX, platform="LINUX"),
    dict(webdriver.DesiredCapabilities.OPERA, platform="LINUX"),

    dict(webdriver.DesiredCapabilities.IPAD, version="6", platform="MAC"),
    dict(webdriver.DesiredCapabilities.IPAD, version="5", platform="MAC"),
    dict(webdriver.DesiredCapabilities.IPHONE, version="6", platform="MAC"),
    dict(webdriver.DesiredCapabilities.IPHONE, version="5", platform="MAC"),
    # dict(webdriver.DesiredCapabilities.ANDROID),
]

# Generate unit test classes for each platform
classes = {}
for platform in PLATFORMS:
    d = dict(FlambeTest.__dict__)
    name = "%s_%s_%s_%s" % (FlambeTest.__name__, platform["browserName"],
        platform.get("platform", "ANY"), random.randint(0, 999))
    name = name.replace(" ", "").replace(".", "")
    d.update({"__test__": True, "caps": platform})
    classes[name] = new.classobj(name, (FlambeTest,), d)

globals().update(classes)
