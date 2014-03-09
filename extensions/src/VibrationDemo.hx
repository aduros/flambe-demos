//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;

// https://www.adobe.com/devnet/air/native-extensions-for-air/extensions/vibration.html
import com.adobe.nativeExtensions.Vibration;

class VibrationDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Vibration");
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        return MenuScene.create(ctx, name, [
            "Vibrate", function () {
                if (Vibration.isSupported) {
                    new Vibration().vibrate(500);
                } else {
                    trace("Vibration not supported!");
                }
            },
        ]);
    }
}
