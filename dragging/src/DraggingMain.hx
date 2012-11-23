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
        var tentacleLayer = new Entity();
        for (ii in 0...10) {
            var sprite = new ImageSprite(pack.getTexture("tentacle"));
            sprite.x._ = Math.random() * (System.stage.width-sprite.getNaturalWidth());
            sprite.y._ = Math.random() * (System.stage.height-sprite.getNaturalHeight());
            sprite.setScale(0.5 + Math.random()*4);
            sprite.rotation._ = Math.random()*90;
            sprite.centerAnchor();

            var tentacle = new Entity().add(sprite).add(new Draggable());
            tentacleLayer.addChild(tentacle);
        }
        System.root.addChild(tentacleLayer);

        // Make them zoomable using the mouse wheel or pinching, depending on device support. Note
        // that some environments may have both a mouse and a touch screen
        if (System.mouse.supported) {
            addScrollListener(tentacleLayer);
        }
        if (System.touch.supported) {
            addPinchListener(tentacleLayer);
        }
    }

    private static function addScrollListener (tentacleLayer :Entity)
    {
        System.mouse.scroll.connect(function (velocity :Float) {
            var target = Sprite.hitTest(tentacleLayer, System.mouse.x, System.mouse.y);
            if (target != null) {
                target.scaleX._ += 0.1*velocity;
                target.scaleY._ = target.scaleX._;
            }
        });
    }

    private static function addPinchListener (tentacleLayer :Entity)
    {
        var pointA = null, pointB = null;
        var startDistance = -1.0;
        var startScale = -1.0;
        var target = null;

        System.touch.down.connect(function (newPoint :TouchPoint) {
            var points = System.touch.points;
            switch (points.length) {
            case 1: // First touch, record the sprite under the finger
                target = Sprite.hitTest(tentacleLayer, newPoint.viewX, newPoint.viewY);
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
}
