//
// Flambe - Rapid game development
// http://2dkit.com

package shmup;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.scene.Director;

class Main
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        var director = new Director();
        System.root.add(director);

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        System.loadAssetPack(manifest).get(function (bootstrapPack) {

            // Then load the bulk of game's assets from the main pack
            var promise = System.loadAssetPack(Manifest.build("main"));
            promise.get(function (mainPack) {
                var ctx = new ShmupContext(mainPack, director);
                ctx.enterHomeScene(false);

                // Free up the preloader assets to save memory
                bootstrapPack.dispose();
            });

            // Show a simple preloader while the main pack is loading
            var preloader = PreloaderScene.create(bootstrapPack, promise);
            director.unwindToScene(preloader);
        });
    }
}
