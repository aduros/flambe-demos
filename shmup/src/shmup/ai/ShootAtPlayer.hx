//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup.ai;

import flambe.Component;
import flambe.display.Sprite;

class ShootAtPlayer extends Component
{
    public function new (ctx :ShmupContext, rateOfFire :Float)
    {
        _ctx = ctx;
        _rateOfFire = rateOfFire;
    }

    override public function onUpdate (dt :Float)
    {
        _timeSinceLastShot += dt;
        if (_timeSinceLastShot > _rateOfFire) {
            _timeSinceLastShot = 0;

            var sprite = owner.get(Sprite);
            var player = _ctx.level.player.get(Sprite);
            if (player != null) {
                var dx = player.x._ - sprite.x._;
                var dy = player.y._ - sprite.y._;
                var distance = Math.sqrt(dx*dx + dy*dy);

                var velX = LevelModel.BULLET_SPEED * dx/distance;
                var velY = LevelModel.BULLET_SPEED * dy/distance;
                _ctx.level.shootFromEnemy(owner, velX, velY);
            }
        }
    }

    private var _ctx :ShmupContext;
    private var _turnRate :Float;
    private var _velY :Float;

    private var _rateOfFire :Float;
    private var _timeSinceLastShot :Float = 0;
}
