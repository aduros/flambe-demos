//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;

// https://code.google.com/p/appirater-ane
import com.palDeveloppers.ane.Appirater;

class AppiraterDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Appirater");
    }

    override public function init ()
    {
#if ios
        Appirater.instance.setAppId("12345");
#end
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        return MenuScene.create(ctx, name, [
#if ios
            "Call appEnteredForeground", function () {
                Appirater.instance.appEnteredForeground(true);
            },
            "Call userDidSignificantEvent", function () {
                Appirater.instance.userDidSignificantEvent(true);
            },
            "Call rateApp", function () {
                Appirater.instance.rateApp();
            },
#end
        ]);
    }
}
