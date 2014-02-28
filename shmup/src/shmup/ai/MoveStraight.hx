//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup.ai;

import flambe.Component;
import flambe.display.Sprite;
import flambe.math.FMath;

class MoveStraight extends Component
{
    public function new (ctx :ShmupContext, velX :Float, velY :Float)
    {
        _ctx = ctx;
        _velX = velX;
        _velY = velY;
    }

    override public function onAdded ()
    {
        var sprite = owner.get(Sprite);
        sprite.rotation._ = FMath.toDegrees(Math.atan2(_velY, _velX)) + 90;
    }

    override public function onUpdate (dt :Float)
    {
        var sprite = owner.get(Sprite);
        sprite.x._ += _velX*dt;
        sprite.y._ += _velY*dt;
    }

    private var _ctx :ShmupContext;
    private var _velX :Float;
    private var _velY :Float;
}
