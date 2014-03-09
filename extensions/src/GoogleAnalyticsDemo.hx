//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;

// https://github.com/alebianco/ANE-Google-Analytics
import eu.alebianco.air.extensions.analytics.Analytics;
import eu.alebianco.air.extensions.analytics.api.ITracker;

class GoogleAnalyticsDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Google Analytics");
    }

    override public function init ()
    {
        trace("is supported? " + Analytics.isSupported());
        _tracker = Analytics.getInstance().getTracker("UA-9490853-17");
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        return MenuScene.create(ctx, name, [
            "Track view", function () {
                _tracker.buildView("TestView").track();
            },
            "Track event", function () {
                _tracker.buildEvent("TestEvent", "test").track();
            },
            "Track timing", function () {
                _tracker.buildTiming("TestTiming", 5000).track();
            },
            "Track error", function () {
                _tracker.buildException(true).withDescription("Just a test error").track();
            },
        ]);
    }

    private var _tracker :ITracker;
}
