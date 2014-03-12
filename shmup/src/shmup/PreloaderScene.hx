//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.PatternSprite;
import flambe.display.Sprite;
import flambe.util.Promise;

class PreloaderScene
{
    /** Creates a scene which shows a preloader progress bar. */
    public static function create (pack :AssetPack, promise :Promise<Dynamic>) :Entity
    {
        var scene = new Entity();

        // Add a solid dark background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        scene.addChild(new Entity().add(background));

        var left = new ImageSprite(pack.getTexture("progress/Left"));
        var right = new ImageSprite(pack.getTexture("progress/Right"));

        var padding = 20;
        var progressWidth = System.stage.width - left.texture.width - right.texture.width - 2*padding;
        var y = System.stage.height/2 - left.texture.height;

        // Add the left end of the progress bar
        left.setXY(padding, y);
        scene.addChild(new Entity().add(left));

        // Add the progress bar background
        var background = new PatternSprite(pack.getTexture("progress/Background"), progressWidth);
        background.setXY(left.x._ + left.texture.width, y);
        scene.addChild(new Entity().add(background));

        // Add the progress bar fill directly on top of the background
        var fill = new PatternSprite(pack.getTexture("progress/Fill"));
        fill.setXY(background.x._, y);
        promise.progressChanged.connect(function () {
            // When the promise has updated progress, resize the progress bar fill
            fill.width._ = promise.progress/promise.total * progressWidth;
        });
        scene.addChild(new Entity().add(fill));

        // Add the right end of the progress bar
        right.setXY(fill.x._ + progressWidth, y);
        scene.addChild(new Entity().add(right));

        return scene;
    }
}
