//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;
import flambe.System;

// https://github.com/heitara/Admob-ANE
import com.hdi.nativeExtensions.NativeAds;

class AdmobDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Admob");
    }

    override public function init ()
    {
#if android
         NativeAds.setUnitId("a1531befba48e97"); // Publisher ID
#elseif ios
         NativeAds.setUnitId("a1531bf2b4b258e"); // Publisher ID
#end

         // Serve real production ads
         NativeAds.setAdMode(true);

         // NativeAds.initAd(0, 0, 320, 50);
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        return MenuScene.create(ctx, name, [
            "Show ad", function () {
                NativeAds.showAd(0, System.stage.height-50, 320, 50);
            },
            "Remove ad", function () {
                NativeAds.removeAd();
            },
        ]);
    }
}
