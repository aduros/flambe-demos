//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.scene.Director;
import flambe.scene.SlideTransition;
import flambe.swf.Flipbook;
import flambe.swf.Library;
import flambe.util.MessageBundle;

/** Contains all the game state that needs to get passed around. */
class ShmupContext
{
    /** The main asset pack. */
    public var pack (default, null) :AssetPack;

    public var director (default, null) :Director;

    // Some constructed assets
    public var messages (default, null) :MessageBundle;
    public var lightFont (default, null) :Font;
    public var darkFont (default, null) :Font;
    public var lib (default, null) :Library;

    /** The currently active level. */
    public var level :LevelModel;

    public function new (mainPack :AssetPack, localePack :AssetPack, director :Director)
    {
        this.pack = mainPack;
        this.director = director;

        this.messages = MessageBundle.parse(localePack.getFile("messages.ini").toString());
        this.lightFont = new Font(pack, "fonts/Light");
        this.darkFont = new Font(pack, "fonts/Dark");

        this.lib = Library.fromFlipbooks([
            // An explosion animation from a 13x1 spritesheet
            new Flipbook("explosion", pack.getTexture("Explosion").split(13))
                .setDuration(0.5).setAnchor(20, 20),
        ]);
    }

    public function enterHomeScene (animate :Bool = true)
    {
        director.unwindToScene(HomeScene.create(this),
            animate ? new SlideTransition(0.5, Ease.quadOut) : null);
    }

    public function enterPlayingScene (animate :Bool = true)
    {
        director.unwindToScene(PlayingScene.create(this),
            animate ? new SlideTransition(0.5, Ease.quadOut) : null);
    }

    public function showPrompt (text :String, buttons :Array<Dynamic>)
    {
        director.pushScene(PromptScene.create(this, text, buttons));
    }
}
