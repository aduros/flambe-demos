import flambe.animation.Easing;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.debug.FpsDisplay;
import flambe.debug.LogVisitor;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.script.CallFunction;
import flambe.script.MoveTo;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.swf.Library;
import flambe.swf.MovieSprite;
import flambe.System;

class BellaMain
{
    public static function onSuccess (pack :AssetPack)
    {
        System.stage.lockOrientation(Landscape);

        var room = new Entity()
            .add(new ImageSprite(pack.loadTexture("background.png")));

        var lib = new Library(pack, "bella");

        for (x in [ 150 ]) {
            var npc = new Entity()
                .add(lib.movie("dance_01"));
            var sprite = npc.get(Sprite);
            sprite.setXY(x, 240);
            sprite.scaleX._ = (x > 400) ? 1 : -1;
            room.addChild(npc);
        }

        var avatar = new Entity()
            .add(new Script())
            .add(new Sprite());
        var sprite = avatar.get(Sprite);
        sprite.setXY(150, 400);

        var walking = new Entity().add(lib.movie("walk"));
        var dancing = new Entity().add(lib.movie("dance_01"));

        walking.get(Sprite).y._ = dancing.get(Sprite).y._ = -180; // Fix anchors...

        avatar.addChild(dancing);
        room.addChild(avatar);

        System.pointer.down.connect(function (event) {
            avatar.removeChild(dancing);
            avatar.addChild(walking);

            sprite.scaleX._ = (sprite.x._ < event.viewX) ? -1 : 1;

            var x = Math.max(150, event.viewX);
            var y = Math.max(380, event.viewY);

            var dx = sprite.x._ - x;
            var dy = sprite.y._ - y;
            var dist = Math.sqrt(dx*dx + dy*dy);

            var script = avatar.get(Script);
            script.stopAll();
            script.run(new Sequence([
                new MoveTo(x, y, dist/250, Easing.linear),
                new CallFunction(function () {
                    avatar.removeChild(walking);
                    avatar.addChild(dancing);
                }),
            ]));
        });

        System.root.addChild(room);

        var fps = new Entity()
            .add(new TextSprite(new Font(pack, "tinyfont")))
            .add(new FpsDisplay());
        System.root.addChild(fps);
    }

    private static function main ()
    {
        System.init();

        var loader = System.loadAssetPack(Manifest.build("bootstrap"));
        loader.get(onSuccess);
    }
}
