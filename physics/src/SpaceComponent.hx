import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.math.FMath;

/**
 * Component that wraps a Nape physics simulation.
 */
class SpaceComponent extends Component
{
    public function new (pack :AssetPack)
    {
        _space = new Space(new Vec2(0, 200));
        _pack = pack;
    }

    override public function onUpdate (dt :Float)
    {
        _space.step(dt);
    }

    public function addBody (body :Body) :Entity
    {
        body.space = _space;
        return new Entity().add(new BodyComponent(body));
    }

    public function addBox (x :Float, y :Float) :Entity
    {
        var body = new Body();
        body.shapes.add(new Polygon(Polygon.box(64, 64), Material.wood()));
        body.position = new Vec2(x, y);
        body.rotation = Math.random() * 2*FMath.PI;

        var entity = addBody(body);
        entity.add(new ImageSprite(_pack.loadTexture("box.png")).centerAnchor());
        return entity;
    }

    public function addBall (x :Float, y :Float) :Entity
    {
        var body = new Body();
        body.shapes.add(new Circle(32, Material.rubber()));
        body.position = new Vec2(x, y);
        body.rotation = Math.random() * 2*FMath.PI;

        var entity = addBody(body);
        entity.add(new ImageSprite(_pack.loadTexture("ball.png")).centerAnchor());
        return entity;
    }

    private var _space :Space;
    private var _pack :AssetPack;
}

