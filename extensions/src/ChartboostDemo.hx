//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;
import flambe.System;

// https://github.com/freshplanet/ANE-Chartboost
import com.freshplanet.ane.AirChartboost;

class ChartboostDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Chartboost");
    }

    override public function init ()
    {
#if android
        // App ID, app signature
        AirChartboost.getInstance().startSession("531bf519f8975c56605bf213",
            "f721dd55ae4185f59e9dcf7e8055747f14b95ae7");
#elseif ios
        AirChartboost.getInstance().startSession("531bf72bf8975c565bb2beec",
            "368ff356f0b0b7aaaa4a4f1d9f03b71be5f5c705");
#end
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        return MenuScene.create(ctx, name, [
            "Show interstitial", function () {
                AirChartboost.getInstance().showInterstitial();
            },
            "Cache interstitial", function () {
                AirChartboost.getInstance().cacheInterstitial();
            },
        ]);
    }
}
