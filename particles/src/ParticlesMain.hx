import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.EmitterMold;
import flambe.display.EmitterSprite;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.input.PointerEvent;

class ParticlesMain
{
    private static function onSuccess (pack :AssetPack)
    {
        System.root.add(new FillSprite(0x202020, System.stage.width, System.stage.height));

        // Cycle through these emitter types
        var molds = [
            new EmitterMold(pack, "explode"),
            new EmitterMold(pack, "love"),
            new EmitterMold(pack, "snow"),
        ];
        var moldIdx = 0;

        // The current emitter
        var emitter :EmitterSprite = null;

        // Have the emitter follow the pointer
        var moveEmitter = function (event) {
            // Set the emitX/Y rather than the sprite.x/y
            emitter.emitX._ = event.viewX;
            emitter.emitY._ = event.viewY;
        };
        System.pointer.down.connect(moveEmitter);
        System.pointer.move.connect(moveEmitter);

        // Restart the emitter on a click
        System.pointer.down.connect(function (_) emitter.restart());

        var changeEmitter = function (idx) {
            moldIdx = idx;

            if (emitter != null) {
                emitter.dispose(); // Destroy any previous emitter
            }
            emitter = molds[idx].createEmitter();
            System.root.addChild(new Entity().add(emitter));
        }
        changeEmitter(0);

        var nextButton = new ImageSprite(pack.getTexture("next"));
        nextButton.setXY(System.stage.width - nextButton.getNaturalWidth(),
            System.stage.height - nextButton.getNaturalHeight());
        nextButton.pointerDown.connect(function (_) {
            changeEmitter((moldIdx+1) % molds.length); // Switch to the next emitter
        });
        System.root.addChild(new Entity().add(nextButton));
    }

    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }
}
