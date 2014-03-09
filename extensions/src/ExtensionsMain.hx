//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.System;
import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.scene.SlideTransition;

class ExtensionsMain
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
        var ctx = new AppContext(pack);
        System.root.add(ctx.director);

#if air
        var demos = [
            new VibrationDemo(),
            new FlurryDemo(),
            // new BurstlyDemo(),
            new PlayhavenDemo(),
            new AdmobDemo(),
            new ChartboostDemo(),
            new AppiraterDemo(),
            new GoogleAnalyticsDemo(),
        ];

        var buttons :Array<Dynamic> = [];
        for (demo in demos) {
            demo.init();

            buttons = buttons.concat([demo.name, function () {
                ctx.director.pushScene(demo.createScene(ctx), new SlideTransition(0.5));
            }]);
        }

        ctx.director.unwindToScene(MenuScene.create(ctx, "Extensions", buttons, false));

#else
        ctx.director.unwindToScene(MenuScene.create(ctx, "No native extensions, run this in AIR!", [], false));
#end

//         System.root.addChild(new Entity()
//             .add(new FillSprite(0x202020, System.stage.width, System.stage.height)));

//         var font = new Font(pack, "handel");
//         var label = new TextSprite(font, "Native extensions not supported here.").setAlign(Center);
//         label.setXY(System.stage.width/2, System.stage.height/2 - font.size/2);
//         System.root.addChild(new Entity().add(label));

// #if air
//         // Vibrate using Adobe's native extension
//         if (Vibration.isSupported) {
//             var vibe = new Vibration();
//             System.pointer.down.connect(function (_) {
//                 vibe.vibrate(500);
//             });
//         }

//         // Initialize Burstly and Flurry APIs. Put your own API keys here
// #if android
//         Burstly.getInstance().init("3cfZ-VoWjUyjSa7gd31OCg", "", "0157980159069224142");
//         Flurry.getInstance().setAndroidAPIKey("JYH5JZC3PBCWYJ8W4Y95");

// #elseif ios
//         Burstly.getInstance().init("dUqvPAtP0ECSPfLfvPuCeQ", "", "0952153959126224962");
//         Flurry.getInstance().setIOSAPIKey("4BCG4Z4V7D3KGW5WP6Z6");
// #end

//         // Load an advert in the background so it's ready when we need it
//         Burstly.getInstance().cacheInterstitial();

//         var tapsLeft = 3;
//         label.text = "Tap to advance to the next level!";

//         System.pointer.down.connect(function (_) {
//             --tapsLeft;
//             if (tapsLeft <= 0) {
//                 tapsLeft = 3;

//                 // Log an event in Flurry
//                 Flurry.getInstance().logEvent("Level complete");

//                 // And show an interstitial ad using Burstly
//                 Burstly.getInstance().showInterstitial();
//             }

//             label.text = tapsLeft + " more taps until the next level.";
//         });
// #end
    }
}
