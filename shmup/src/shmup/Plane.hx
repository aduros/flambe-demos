//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Component;
import flambe.display.ImageSprite;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Signal0;

/** Logic for planes. */
class Plane extends Component
{
    public var radius (default, null) :Float;
    public var health (default, null) :Float;

    /** Emitted when this plane is destroyed. */
    public var destroyed (default, null) :Signal0;

    public function new (ctx :ShmupContext, name :String, radius :Float, health :Float)
    {
        _ctx = ctx;
        _name = name;
        this.radius = radius;
        this.health = health;
        destroyed = new Signal0();
    }

    override public function onAdded ()
    {
        var normal = _ctx.pack.getTexture("planes/"+_name);
        var sprite = owner.get(ImageSprite);
        if (sprite == null) {
            owner.add(sprite = new ImageSprite(normal));
        }
        sprite.texture = normal;
        sprite.centerAnchor();
    }

    /** Deal damage to this plane, returns true if it was destroyed. */
    public function damage (amount :Float) :Bool
    {
        if (amount >= health) {
            health = 0;
            destroyed.emit();
            owner.dispose();
            return true;

        } else {
            var hit = _ctx.pack.getTexture("planes/"+_name+"_hit");
            var sprite = owner.get(ImageSprite);

            var oldTexture = sprite.texture;
            if (oldTexture != hit) {
                // Switch to the hit display state
                sprite.texture = hit;

                // And switch back after a moment
                var script = owner.get(Script);
                if (script == null) {
                    owner.add(script = new Script());
                }
                script.run(new Sequence([
                    new Delay(0.1),
                    new CallFunction(function () {
                        sprite.texture = oldTexture;
                    }),
                ]));
            }

            _ctx.pack.getSound("sounds/Hurt").play();

            health -= amount;
            return false;
        }
    }

    private var _ctx :ShmupContext;
    private var _name :String;
}
