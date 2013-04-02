#!/usr/bin/env python
#
# Runs Selenium integration tests via Sauce Labs. This assumes that the Flambe app is available at
# http://localhost:5000.

import base64
import httplib
import json
import os
import sys
import unittest

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait

class FlambeTest(unittest.TestCase):
    def setUp (self):
        self.username = "flambe"
        self.key = os.environ["SAUCE_ACCESS_KEY"]

        # TODO(bruno): Run on all zillion browser platforms
        opts = webdriver.DesiredCapabilities.IPHONE
        opts["version"] = "5.0"
        opts["platform"] = "MAC"
        opts["name"] = "Flambe Selenium"
        if os.environ.get("TRAVIS"):
            opts["tunnel-identifier"] = os.environ["TRAVIS_JOB_NUMBER"]
            opts["build"] = os.environ["TRAVIS_BUILD_NUMBER"]
            opts["tags"] = [os.environ["TRAVIS_BRANCH"], "CI"]

        # localhost:4445 gets tunneled over Sauce Connect
        hub_url = "http://%s:%s@localhost:4445/wd/hub" % (self.username, self.key)
        self.driver = webdriver.Remote(desired_capabilities=opts, command_executor=hub_url)

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
            status[0] = driver.execute_script("return $flambe_selenium_status")
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

if __name__ == "__main__":
    unittest.main()
