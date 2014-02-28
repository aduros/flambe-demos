//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup.ai;

import flambe.Component;
import flambe.display.Sprite;
import flambe.math.Point;
import flambe.math.FMath;

class ShootStraight extends Component
{
    public function new (ctx :ShmupContext, rateOfFire :Float)
    {
        _ctx = ctx;
        _rateOfFire = rateOfFire;
        _velocities = [];
    }

    public function single () :ShootStraight
    {
        _velocities.push(new Point(0, 0.75*LevelModel.BULLET_SPEED));
        return this;
    }

    public function multi (angle :Float, count :Int) :ShootStraight
    {
        var startAngle = -angle/2 + 90;
        var step = angle/(count-1);

        for (ii in 0...count) {
            var rad = FMath.toRadians(startAngle + step*ii);
            var vel = new Point(Math.cos(rad), Math.sin(rad));
            vel.multiply(0.75*LevelModel.BULLET_SPEED);
            _velocities.push(vel);
        }
        return this;
    }

    override public function onUpdate (dt :Float)
    {
        _timeSinceLastShot += dt;
        if (_timeSinceLastShot > _rateOfFire) {
            _timeSinceLastShot = 0;

            for (vel in _velocities) {
                _ctx.level.shootFromEnemy(owner, vel.x, vel.y);
            }
        }
    }

    private var _ctx :ShmupContext;

    private var _rateOfFire :Float;
    private var _timeSinceLastShot :Float = 0;

    private var _velocities :Array<Point>;
}
