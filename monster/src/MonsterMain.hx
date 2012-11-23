import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.input.MouseCursor;
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

        // Clicking on the monster plays an attack animation
        monster.get(Sprite).pointerDown.connect(function (event) {
            monster.get(MoviePlayer).play("attack");
        });

        // Create a cupcake that follows the pointer
        var cupcake = new ImageSprite(pack.getTexture("cupcake"))
            .centerAnchor().disablePointer();
        System.pointer.move.connect(function (event) {
            cupcake.setXY(event.viewX, event.viewY);
        });
        System.root.addChild(new Entity().add(cupcake));

        // Hide the mouse cursor
        System.mouse.cursor = None;
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
