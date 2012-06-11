import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.Entity;
import flambe.System;
import flambe.display.FillSprite;

class PhysicsMain
{
    private static function onSuccess (pack :AssetPack)
    {
        var space = new SpaceComponent(pack);
        var world = new Entity()
            .add(space)
            .add(new FillSprite(0xf0f0f0, System.stage.width, System.stage.height));
        System.root.addChild(world);

        // Since the box and ball images aren't in a texture atlas in this demo, put each type of
        // body in its own layer to make the drawing order more batch-friendly for GPU renderers
        var boxLayer = new Entity();
        world.addChild(boxLayer);

        var ballLayer = new Entity();
        world.addChild(ballLayer);

        // On a tap, create a new box or ball
        System.pointer.down.connect(function (event) {
            if (Math.random() < 0.75) {
                boxLayer.addChild(space.addBox(event.viewX, event.viewY));
            } else {
                ballLayer.addChild(space.addBall(event.viewX, event.viewY));
            }
        });

        addFloor(world);
    }

    private static function addFloor (world :Entity)
    {
        var padX = 100;
        var padY = 30;
        var x = padX;
        var y = System.stage.height - padY;
        var width = System.stage.width - 2*padX;
        var height = 10;

        var space = world.get(SpaceComponent);
        var floorBody = new Body(BodyType.STATIC);
        floorBody.shapes.add(new Polygon(Polygon.rect(x, y, width, height)));
        space.addBody(floorBody);

        var floorEntity = new Entity()
            .add(new FillSprite(0x202020, width, height).setXY(x, y));
        world.addChild(floorEntity);
    }

    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }
}
