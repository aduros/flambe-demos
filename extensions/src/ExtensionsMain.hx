import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

#if air
import com.adobe.nativeExtensions.Vibration;
import com.freshplanet.ane.airBurstly.Burstly;
import com.freshplanet.nativeExtensions.Flurry;
#end

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
        System.root.addChild(new Entity()
            .add(new FillSprite(0x202020, System.stage.width, System.stage.height)));

        var font = new Font(pack, "handel");
        var label = new TextSprite(font, "Native extensions not supported here.").setAlign(Center);
        label.setXY(System.stage.width/2, System.stage.height/2 - font.size/2);
        System.root.addChild(new Entity().add(label));

#if air
        // Vibrate using Adobe's native extension
        if (Vibration.isSupported) {
            var vibe = new Vibration();
            System.pointer.down.connect(function (_) {
                vibe.vibrate(500);
            });
        }

        // Initialize Burstly and Flurry APIs. Put your own API keys here
#if android
        Burstly.getInstance().init("3cfZ-VoWjUyjSa7gd31OCg", "", "0157980159069224142");
        Flurry.getInstance().setAndroidAPIKey("JYH5JZC3PBCWYJ8W4Y95");

#elseif ios
        Burstly.getInstance().init("dUqvPAtP0ECSPfLfvPuCeQ", "", "0952153959126224962");
        Flurry.getInstance().setIOSAPIKey("4BCG4Z4V7D3KGW5WP6Z6");
#end

        // Load an advert in the background so it's ready when we need it
        Burstly.getInstance().cacheInterstitial();

        var tapsLeft = 3;
        label.text = "Tap to advance to the next level!";

        System.pointer.down.connect(function (_) {
            --tapsLeft;
            if (tapsLeft <= 0) {
                tapsLeft = 3;

                // Log an event in Flurry
                Flurry.getInstance().logEvent("Level complete");

                // And show an interstitial ad using Burstly
                Burstly.getInstance().showInterstitial();
            }

            label.text = tapsLeft + " more taps until the next level.";
        });
#end
    }
}
