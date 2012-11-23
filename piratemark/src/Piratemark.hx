import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.debug.FpsDisplay;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.System;

class Piratemark
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
        var background = new Entity()
            .add(new FillSprite(0xffffff, System.stage.width, System.stage.height));
        System.root.addChild(background);

        // Resize the background when the stage resizes
        System.stage.resize.connect(function () {
            var sprite = background.get(FillSprite);
            sprite.width._ = System.stage.width;
            sprite.height._ = System.stage.height;
        });

        // Add a bunch of pirates
        for (ii in 0...10) {
            var pirate = new Entity()
                .add(new ImageSprite(pack.getTexture("pirate")))
                .add(new Bouncy());
            var sprite = pirate.get(Sprite);
            sprite.setXY(Math.random()*System.stage.width, Math.random()*System.stage.height);
            sprite.setScale(Math.random() + 0.5);
            sprite.centerAnchor();

            System.root.addChild(pirate);
        }

        // Show an FPS display
        System.root.addChild(new Entity()
            .add(new TextSprite(new Font(pack, "tinyfont")))
            .add(new FpsDisplay()));
    }
}
