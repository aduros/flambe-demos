//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;

// https://github.com/freshplanet/ANE-Burstly
import com.freshplanet.ane.airBurstly.Burstly;

class BurstlyDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Burstly");
    }

    override public function init ()
    {
#if android
         Burstly.getInstance().init("3cfZ-VoWjUyjSa7gd31OCg", "", "0157980159069224142");
#elseif ios
         Burstly.getInstance().init("dUqvPAtP0ECSPfLfvPuCeQ", "", "0952153959126224962");
#end
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        return MenuScene.create(ctx, name, [
            "Show interstitial", function () {
                Burstly.getInstance().showInterstitial();
            },
        ]);
    }
}
