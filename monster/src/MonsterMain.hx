import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;

class MonsterMain
{
    private static function onSuccess (pack :AssetPack)
    {
        System.root.addChild(new Entity()
            .add(new FillSprite(0xf0f0f0, System.stage.width, System.stage.height)));

        var monster = new Entity()
            .add(new MoviePlayer(new Library(pack, "monster")).loop("idle"))
            .add(new Sprite().setXY(System.stage.width, System.stage.height))
            .add(new MonsterAI());
        System.root.addChild(monster);

        monster.get(Sprite).pointerDown.connect(function (event) {
            monster.get(MoviePlayer).play("attack");
        });

        var cupcake = new ImageSprite(pack.loadTexture("cupcake.png")).centerAnchor();
        cupcake.pointerEnabled = false;
        System.pointer.move.connect(function (event) {
            cupcake.setXY(event.viewX, event.viewY);
        });
        System.root.addChild(new Entity().add(cupcake));
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
