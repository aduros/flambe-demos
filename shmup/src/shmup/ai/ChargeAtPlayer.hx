//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup.ai;

import flambe.Component;
import flambe.display.Sprite;

class ChargeAtPlayer extends Component
{
    public function new (ctx :ShmupContext, turnRate :Float, velY :Float)
    {
        _ctx = ctx;
        _turnRate = turnRate;
        _velY = velY;
    }

    override public function onUpdate (dt :Float)
    {
        var sprite = owner.get(Sprite);
        sprite.rotation._ = 180;
        sprite.y._ += _velY*dt;

        var player = _ctx.level.player.get(Sprite);
        if (player != null) {
            var dx = player.x._ - sprite.x._;
            var travel = Math.abs(dx)/100 * _turnRate*dt;
            if (dx > travel) {
                sprite.x._ += travel;
            } else if (dx < -travel) {
                sprite.x._ -= travel;
            }
        }
    }

    private var _ctx :ShmupContext;
    private var _turnRate :Float;
    private var _velY :Float;
}
