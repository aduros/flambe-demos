//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Entity;
import flambe.System;
import flambe.animation.Ease;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.util.Promise;

class HomeScene
{
    /** Creates the main menu scene. */
    public static function create (ctx :ShmupContext) :Entity
    {
        var scene = new Entity();

        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        scene.addChild(new Entity().add(background));

        var play = new ImageSprite(ctx.pack.getTexture("buttons/PlayBig"));
        play.centerAnchor().setXY(System.stage.width/2, System.stage.height/2);
        play.scaleX.animate(0.5, 1, 0.5, Ease.backOut);
        play.scaleY.animate(0.5, 1, 0.5, Ease.backOut);
        play.pointerDown.connect(function (_) {
            ctx.pack.getSound("sounds/Coin").play();
            ctx.enterPlayingScene();
        });
        scene.addChild(new Entity().add(play));

        return scene;
    }
}
