//
// Flambe - Rapid game development
// http://2dkit.com

package shmup;

import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.scene.Director;
import flambe.scene.SlideTransition;
import flambe.swf.Flipbook;
import flambe.swf.Library;

/** Contains all the game state that needs to get passed around. */
class ShmupContext
{
    /** The main asset pack. */
    public var pack (default, null) :AssetPack;

    public var director (default, null) :Director;

    // Some constructed assets
    public var lightFont (default, null) :Font;
    public var darkFont (default, null) :Font;
    public var lib (default, null) :Library;

    /** The currently active level. */
    public var level :LevelModel;

    public function new (pack :AssetPack, director :Director)
    {
        this.pack = pack;
        this.director = director;

        this.lightFont = new Font(pack, "fonts/Light");
        this.darkFont = new Font(pack, "fonts/Dark");

        this.lib = Library.fromFlipbooks({
            // An explosion animation from a 13x1 spritesheet
            "explosion": new Flipbook(pack.getTexture("Explosion").split(13))
                .setDuration(0.5).setAnchor(20, 20),
        });
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
