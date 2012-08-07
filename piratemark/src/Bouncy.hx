import flambe.Component;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.System;

class Bouncy extends Component
{
    public function new ()
    {
        _vr = FMath.toDegrees(Math.random()*0.2 - 0.1);
        _vx = Math.random()*70 - 35;
        _vy = Math.random()*70 - 35;
    }

    override public function onUpdate (dt :Float)
    {
        var sprite = owner.get(Sprite);
        var w = System.stage.width;
        var h = System.stage.height;

        var perSecond = 1000*0.05*dt;
        sprite.x._ += _vx*perSecond;
        sprite.y._ += _vy*perSecond;
        sprite.rotation._ += _vr*perSecond;

        _vy += 0.75*perSecond;

        if (sprite.y._ > h) {
            _vy *= -0.8;
            sprite.y._ = h;
            if (Math.random() < 0.5) {
                _vy -= Math.random()*12;
            }
        }

        if (sprite.x._ > w) {
            _vx *= -0.8;
            sprite.x._ = w;

        } else if (sprite.x._ < 0) {
            _vx *= -0.8;
            sprite.x._ = 0;
        }
    }

    private var _vx :Float;
    private var _vy :Float;
    private var _vr :Float;
}
