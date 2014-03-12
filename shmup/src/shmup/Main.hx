//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

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
        var manifest = Manifest.fromAssets("bootstrap");
        System.loadAssetPack(manifest).get(function (bootstrapPack) {

            // Then load up the pack containing localized assets. Depending on the user's language,
            // this will load either "locale", "locale-es", or "locale-pt". See the docs for
            // Manifest.fromAssetsLocalized() for more info.
            System.loadAssetPack(Manifest.fromAssetsLocalized("locale")).get(function (localePack) {

                // Then finally load the bulk of game's assets from the main pack
                var promise = System.loadAssetPack(Manifest.fromAssets("main"));
                promise.get(function (mainPack) {
                    var ctx = new ShmupContext(mainPack, localePack, director);
                    ctx.enterHomeScene(false);

                    // Free up the preloader assets to save memory
                    bootstrapPack.dispose();
                });

                // Show a simple preloader while the main pack is loading
                var preloader = PreloaderScene.create(bootstrapPack, promise);
                director.unwindToScene(preloader);
            });
        });
    }
}
