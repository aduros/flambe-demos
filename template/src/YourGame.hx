import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;

class YourGame
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
        // Asset pack loaded, do something wonderful

        var background = new Entity()
            .add(new FillSprite(0x0000ff, System.stage.width, System.stage.height));
        System.root.addChild(background);

        var duck = new Entity()
            .add(new ImageSprite(pack.loadTexture("duck.png")));
        duck.get(Sprite).pointerDown.connect(function (event) {
            pack.loadSound("quack").play();
        });
        System.root.addChild(duck);
    }
}
