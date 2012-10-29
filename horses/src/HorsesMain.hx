import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.sound.Playback;
import flambe.swf.Library;
import flambe.swf.MovieSprite;
import flambe.System;

class HorsesMain
{
    private static var pack :AssetPack;
    private static var scene :MovieSprite;

    // Maps the horse to the sound it's currently playing, if any
    private static var playbacks = new IntHash<Playback>();

    private static function onSuccess (pack :AssetPack)
    {
        HorsesMain.pack = pack;

        // Create a dark background
        var background = new FillSprite(0x000000, 0, 0);
        System.root.addChild(new Entity().add(background));

        // Create the horse-filled scene
        var lib = new Library(pack, "hestekor");
        scene = lib.createMovie("scene");
        System.root.addChild(new Entity().add(scene));

        // Pause all horses initially, and add pointer listeners
        for (id in 1...5) {
            var layer = scene.getLayer("horse"+id);
            var sprite = layer.get(MovieSprite);
            sprite.paused = true;
            sprite.pointerDown.connect(function (_) toggleHorse(id));
        }

        // Keep the scene centered on the stage
        var sceneWidth = 550;
        var sceneHeight = 300;
        var onResize = function () {
            scene.x._ = System.stage.width/2 - sceneWidth/2;
            scene.y._ = System.stage.height/2 - sceneHeight/2;
            background.width._ = System.stage.width;
            background.height._ = System.stage.height;
        };
        System.stage.resize.connect(onResize);
        onResize();
    }

    private static function toggleHorse (id :Int)
    {
        var layer = scene.getLayer("horse"+id, false);
        var movie = layer.get(MovieSprite);
        var playback = playbacks.get(id);

        if (playback == null) {
            // Start the sound loop and play the animation
            playbacks.set(id, pack.loadSound("horse"+id).loop());
            movie.paused = false;

        } else {
            // Stop the sound loop and the animation
            playback.dispose();
            playbacks.remove(id);
            movie.paused = true;
            movie.position = 0;
        }
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
