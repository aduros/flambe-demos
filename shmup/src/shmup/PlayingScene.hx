//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Entity;
import flambe.System;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;

class PlayingScene
{
    /** Creates the scene where the gameplay happens. */
    public static function create (ctx :ShmupContext)
    {
        var scene = new Entity();

        var level = new LevelModel(ctx);
        ctx.level = level;
        scene.add(level);

        // Show a score label on the top left
        var scoreLabel = new TextSprite(ctx.darkFont);
        scoreLabel.setXY(5, 5);
        level.score.watch(function (score,_) {
            scoreLabel.text = ""+score;
        });
        scene.addChild(new Entity().add(scoreLabel));

        // Show a pause button
        var pause = new ImageSprite(ctx.pack.getTexture("buttons/Pause"));
        pause.setXY(System.stage.width-pause.texture.width-5, 5);
        pause.pointerDown.connect(function (_) {
            ctx.showPrompt(ctx.messages.get("paused"), [
                "Play", function () {
                    // Unpause by unwinding to the original scene
                    ctx.director.unwindToScene(scene);
                },
                "Home", function () {
                    // Go back to the main menu, unwinding first so the transition looks right
                    ctx.director.unwindToScene(scene);
                    ctx.enterHomeScene();
                },
            ]);
        });
        scene.addChild(new Entity().add(pause));

        return scene;
    }
}
