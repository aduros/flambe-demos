import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

class BrowserMain
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
        System.root.add(new Director());
        System.root.get(Director).unwindToScene(createIntroScene(pack));
    }

    private static function createIntroScene (pack :AssetPack) :Entity
    {
        var scene = new Entity()
            .add(new FillSprite(0x202020, System.stage.width, System.stage.height));

        var downButton = new ImageSprite(pack.getTexture("down"));
        downButton.x._ = System.stage.width/2 - downButton.texture.width/2;
        downButton.y._ = 10;
        downButton.pointerDown.connect(function (_) {
            System.root.get(Director).unwindToScene(createBrowserScene(pack));
        });
        scene.addChild(new Entity().add(downButton));

        return scene;
    }

    private static function createBrowserScene (pack :AssetPack) :Entity
    {
        var scene = new Entity()
            .add(new FillSprite(0x202020, System.stage.width, System.stage.height));

        var font = new Font(pack, "tinyfont");
        var location = new TextSprite(font);
        location.x._ = 10;
        location.y._ = System.stage.height - font.size - 10;
        scene.addChild(new Entity().add(location));

        var closeButton = new ImageSprite(pack.getTexture("close"));
        closeButton.x._ = System.stage.width - closeButton.texture.width;
        closeButton.y._ = System.stage.height - closeButton.texture.height;
        closeButton.pointerDown.connect(function (_) {
            System.root.get(Director).unwindToScene(createIntroScene(pack));
        });
        scene.addChild(new Entity().add(closeButton));

        if (System.web.supported) {
            var view = System.web.createView(0, 0, System.stage.width, 0);
            view.url._ = "http://en.wikipedia.org/wiki/Main_Page";
            view.height.animateTo(location.y._ - 10, 3, Ease.bounceOut);

            view.error.connect(function (error) location.text = "Error: " + error);
            view.url.watch(function (url,_) location.text = url);

            // Ensure the webview is properly disposed when the scene is disposed
            scene.add(new Disposer().add(view));

            var openButton = new ImageSprite(pack.getTexture("open"));
            openButton.x._ = closeButton.x._ - openButton.texture.width;
            openButton.y._ = System.stage.height - closeButton.texture.height;
            openButton.pointerDown.connect(function (_) {
                // Open the current URL in the system browser
                System.web.openBrowser(view.url._);
            });
            scene.addChild(new Entity().add(openButton));

        } else {
            location.text = "WebView is not supported here :(";
        }

        return scene;
    }
}
