import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;

class MonsterMain
{
    private static function onSuccess (pack :AssetPack)
    {
        System.root.addChild(new Entity()
            .add(new FillSprite(0xf0f0f0, System.stage.width, System.stage.height)));

        var monster = new Entity()
            .add(new MonsterAI(pack))
            .add(new Sprite().setXY(System.stage.width, System.stage.height));
        System.root.addChild(monster);

        var cursor = new Entity()
            .add(new ImageSprite(pack.loadTexture("cupcake.png")).centerAnchor());
        System.pointer.move.connect(function (event) {
            cursor.get(Sprite).setXY(event.viewX, event.viewY);
        });
        System.root.addChild(cursor);
    }

    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }
}
