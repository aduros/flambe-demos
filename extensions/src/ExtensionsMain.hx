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
#end

class ExtensionsMain
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
        System.root.addChild(new Entity()
            .add(new FillSprite(0x202020, System.stage.width, System.stage.height)));

        var font = new Font(pack, "handel");
        var label = new TextSprite(font, "Vibration is not supported here");

#if air
        if (Vibration.isSupported) {
            label.text = "Tap anywhere to vibrate...";

            var vibe = new Vibration();
            System.pointer.down.connect(function (_) {
                label.text = "Bzzzzzt!";
                vibe.vibrate(500);
            });
        }
#end

        label.setXY(System.stage.width/2, System.stage.height/2 - font.size/2);
        label.align = Center;

        System.root.addChild(new Entity().add(label));
    }
}
