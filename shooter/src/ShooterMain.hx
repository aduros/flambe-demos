//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.asset.Manifest;
import flambe.System;

class ShooterMain
{
    private static function main ()
    {
        System.init();

        var loader = System.loadAssetPack(Manifest.fromAssets("bootstrap"));
        loader.success.connect(function (pack) {
            ShooterCtx.pack = pack;
            System.root.add(new Game());
        });
        loader.error.connect(function (message) {
            trace("Loading error: " + message);
        });
        loader.progressChanged.connect(function () {
            trace("Loading progress... " + loader.progress + " of " + loader.total);
        });
    }
}
