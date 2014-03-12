//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Component;
import flambe.Entity;
import flambe.System;
import flambe.display.Sprite;

/** Logic for bullets. */
class Bullet extends Component
{
    public function new (ctx :ShmupContext, velX :Float, velY :Float, targets :Array<Entity>)
    {
        _ctx = ctx;
        _velX = velX;
        _velY = velY;
        _targets = targets;
    }

    override public function onUpdate (dt :Float)
    {
        // Move the bullet forward
        var bulletSprite = owner.get(Sprite);
        bulletSprite.x._ += _velX * dt;
        bulletSprite.y._ += _velY * dt;

        if (bulletSprite.x._ < 0 || bulletSprite.x._ > System.stage.width ||
            bulletSprite.y._ < 0 || bulletSprite.y._ > System.stage.height) {
            // Bullet travelled offscreen, remove the entire entity
            owner.dispose();
            return;
        }

        var ii = 0, ll = _targets.length;
        while (ii < ll) {
            var target = _targets[ii];
            var targetSprite = target.get(Sprite);
            var plane = target.get(Plane);

            if (targetSprite != null && plane != null) {
                var dx = targetSprite.x._ - bulletSprite.x._;
                var dy = targetSprite.y._ - bulletSprite.y._;
                if (dx*dx + dy*dy < plane.radius*plane.radius) {
                    owner.dispose();
                    if (plane.damage(1)) {
                        _targets.splice(ii, 1);
                    }
                    return;
                }
            }

            ++ii;
        }
    }

    private var _ctx :ShmupContext;
    private var _velX :Float;
    private var _velY :Float;
    private var _targets :Array<Entity>;
}
