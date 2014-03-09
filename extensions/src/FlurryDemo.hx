//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;

// https://github.com/freshplanet/ANE-Flurry
import com.freshplanet.nativeExtensions.Flurry;

class FlurryDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Flurry");
    }

    override public function init ()
    {
#if android
        Flurry.getInstance().setAndroidAPIKey("JYH5JZC3PBCWYJ8W4Y95");
#elseif ios
        Flurry.getInstance().setIOSAPIKey("4BCG4Z4V7D3KGW5WP6Z6");
#end
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        return MenuScene.create(ctx, name, [
            "Start session", function () {
                Flurry.getInstance().startSession();
            },
            "Log event", function () {
                Flurry.getInstance().logEvent("Test event");
            },
            "Log error", function () {
                Flurry.getInstance().logError("Test error");
            },
            "Stop session", function () {
                Flurry.getInstance().stopSession();
            },
        ]);
    }
}
