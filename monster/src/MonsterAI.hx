import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.swf.MoviePlayer;
import flambe.Entity;
import flambe.System;

class MonsterAI extends Component
{
    public function new ()
    {
    }

    override public function onUpdate (dt :Float)
    {
        var sprite = owner.get(Sprite);
        var walking = false;

        var targetX = System.pointer.x;
        if (targetX != sprite.x._) {
            var left = (targetX < sprite.x._);

            sprite.x._ += dt*SPEED*(left ? -1 : 1);
            if (sprite.x._ < targetX == left) {
                sprite.x._ = targetX;
            }
            sprite.scaleX._ = (left ? 1 : -1) * Math.abs(sprite.scaleX._);
            walking = true;
        }

        var targetY = System.pointer.y;
        if (targetY < 150) {
            targetY = 150;
        }

        if (targetY != sprite.y._) {
            var up = (targetY < sprite.y._);

            sprite.y._ += dt*SPEED*(up ? -1 : 1);
            if (sprite.y._ < targetY == up) {
                sprite.y._ = targetY;
            }

            var scale = 0.5 + 0.2*sprite.y._/System.stage.height;
            sprite.scaleX._ = scale*FMath.sign(sprite.scaleX._);
            sprite.scaleY._ = scale;
            walking = true;
        }

        var player = owner.get(MoviePlayer);
        // Don't interrupt any currently playing oneshot animations
        if (player.looping) {
            player.loop(walking ? "walk" : "idle", false);
        }
    }

    private static inline var SPEED = 100; // pixels per second -ish
}
