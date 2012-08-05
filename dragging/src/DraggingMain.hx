//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.input.TouchPoint;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;

using Lambda;

class DraggingMain
{
    private static function main ()
    {
        System.init();

        var loader = System.loadAssetPack(Manifest.build("bootstrap"));
        // Add listeners
        loader.success.connect(onSuccess);
        loader.error.connect(function (message) {
            trace("Load error: " + message);
        });
        loader.progressChanged.connect(function () {
            trace("Loading progress... " + loader.progress + " of " + loader.total);
        });
    }

    private static function onSuccess (pack :AssetPack)
    {
        // Add a filled background color
        System.root.addChild(new Entity()
            .add(new FillSprite(0x303030, System.stage.width, System.stage.height)));

        // Add a bunch of draggable tentacle sprites
        var tentacles = [];
        for (ii in 0...10) {
            var tentacle = new Entity()
                .add(new ImageSprite(pack.loadTexture("tentacle.png")))
                .add(new Draggable());
            var sprite = tentacle.get(ImageSprite);
            sprite.x._ = Math.random() * (System.stage.width-sprite.getNaturalWidth());
            sprite.y._ = Math.random() * (System.stage.height-sprite.getNaturalHeight());
            sprite.scaleX._ = sprite.scaleY._ = 0.5 + Math.random()*4;
            sprite.rotation._ = Math.random()*90;
            sprite.centerAnchor();
            System.root.addChild(tentacle);

            // Insert backwards to ensure they're sorted by screen depth
            tentacles.unshift(tentacle);
        }

        // Make them zoomable using the mouse wheel or pinching, depending on device support. Note
        // that some environments may have both a mouse and a touch screen
        if (System.mouse.supported) {
            addScrollListener(tentacles);
        }
        if (System.touch.supported) {
            addPinchListener(tentacles);
        }
    }

    private static function addScrollListener (tentacles :Array<Entity>)
    {
        System.mouse.scroll.connect(function (velocity :Float) {
            var target = spriteUnderPoint(tentacles, System.mouse.x, System.mouse.y);
            if (target != null) {
                target.scaleX._ += 0.1*velocity;
                target.scaleY._ = target.scaleX._;
            }
        });
    }

    private static function addPinchListener (tentacles :Array<Entity>)
    {
        var pointA = null, pointB = null;
        var startDistance = -1.0;
        var startScale = -1.0;
        var target = null;

        System.touch.down.connect(function (newPoint :TouchPoint) {
            var points = System.touch.points;
            switch (points.length) {
            case 1: // First touch, record the sprite under the finger
                target = spriteUnderPoint(tentacles, newPoint.viewX, newPoint.viewY);
            case 2: // Initiate the pinching!
                pointA = points[0];
                pointB = points[1];
                var dx = pointA.viewX - pointB.viewX;
                var dy = pointA.viewY - pointB.viewY;
                startDistance = Math.sqrt(dx*dx + dy*dy);
                startScale = target.scaleX._;
            }
        });

        System.touch.move.connect(function (point :TouchPoint) {
            if (pointA != null && target != null) {
                // Calculate the distance between the two pinch points and scale the sprite
                var dx = pointA.viewX - pointB.viewX;
                var dy = pointA.viewY - pointB.viewY;
                var distance = Math.sqrt(dx*dx + dy*dy);
                var scale = startDistance / distance;
                var newScale = startScale / scale;
                target.setScale(newScale);
            }
        });

        System.touch.up.connect(function (oldPoint :TouchPoint) {
            if (System.touch.points.count() < 2) {
                // Stop the pinch gesture
                pointA = pointB = null;
                target = null;
            }
        });
    }

    /** Gets the entity under a point in stage co-ordinates. */
    private static function spriteUnderPoint (tentacles :Array<Entity>, x :Float, y :Float) :Sprite
    {
        for (tentacle in tentacles) {
            var sprite = tentacle.get(Sprite);
            if (sprite.contains(x, y)) {
                return sprite;
            }
        }
        return null;
    }
}
