import haxe.io.Bytes;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.input.PointerEvent;
import flambe.util.Value;

using Lambda;

class PaintMain
{
    private static function onSuccess (pack :AssetPack)
    {
        var brushTexture = null;
        var colors = [0x282828, 0xed5314, 0xffb92a, 0xfeeb51, 0x9bca3e, 0x3abbc9];

        // When selectedColor changes, recreate the brush texture
        var selectedColor = new Value<Int>(colors[0]);
        selectedColor.watch(function (color,_) {
            var source = pack.getTexture("brush");
            var recolored = createRecolor(source, color);
            brushTexture = System.renderer.createTexture(source.width, source.height);
            brushTexture.writePixels(recolored, 0, 0, source.width, source.height);
        });

        var game = new Entity();
        System.root.addChild(game);

        var canvas = System.renderer.createTexture(System.stage.width, System.stage.height);
        canvas.graphics.fillRect(0xe6e6e6, 0, 0, canvas.width, canvas.height);

        // Draw the brush texture when pressing the canvas
        var drawPoint = function (event :PointerEvent) {
            if (System.pointer.isDown()) {
                canvas.graphics.drawImage(brushTexture,
                    event.viewX - brushTexture.width/2, event.viewY - brushTexture.width/2);
            }
        };
        var sprite = new ImageSprite(canvas);
        sprite.pointerDown.connect(drawPoint);
        sprite.pointerMove.connect(drawPoint);
        game.addChild(new Entity().add(sprite));

        // Add the color selection buttons
        for (ii in 0...colors.length) {
            var color = colors[ii];
            var button = new FillSprite(color, 50, 50).setXY(50*ii, 0);
            button.pointerDown.connect(function (_) {
                selectedColor._ = color;
                button.y.animate(4, 0, 0.2);
            });
            game.addChild(new Entity().add(button));
        }

        // Add the blur button
        var blurButton = new ImageSprite(pack.getTexture("blur")).setXY(50*colors.length, 0);
        blurButton.pointerDown.connect(function (_) {
            var blurredPixels = createFilter(canvas, [
                1/9, 1/9, 1/9,
                1/9, 1/9, 1/9,
                1/9, 1/9, 1/9,
            ]);
            canvas.writePixels(blurredPixels, 0, 0, canvas.width, canvas.height);
        });
        game.addChild(new Entity().add(blurButton));
    }

    private static function createRecolor (source :Texture, color :Int) :Bytes
    {
        // Extract the RGB values from the selected color
        var r = (color & 0xff0000) / 0xff0000;
        var g = (color & 0x00ff00) / 0x00ff00;
        var b = (color & 0x0000ff) / 0x0000ff;

        // Repaint all the pixels
        var pixels = source.readPixels(0, 0, source.width, source.height);
        var ii = 0, ll = pixels.length;
        while (ii < ll) {
            pixels.set(ii, Std.int(r*pixels.get(ii)));
            pixels.set(ii+1, Std.int(g*pixels.get(ii+1)));
            pixels.set(ii+2, Std.int(b*pixels.get(ii+2)));
            // Skip the alpha channel
            ii += 4;
        }
        return pixels;
    }

    private static function createFilter (source :Texture, kernel :Array<Float>) :Bytes
    {
        var pixels = source.readPixels(0, 0, source.width, source.height);

        // This could be more optimized/correct
        var w = source.width, h = source.height;
        var output = Bytes.alloc(pixels.length);
        for (y in 0...h) {
            for (x in 0...w) {
                var r = 0.0, g = 0.0, b = 0.0;
                var k = 0;
                for (dy in -1...2) {
                    for (dx in -1...2) {
                        var offset = 4 * (w*(y+dy) + (x+dx));
                        var weight = kernel[k++];
                        r += weight * pixels.get(offset);
                        g += weight * pixels.get(offset+1);
                        b += weight * pixels.get(offset+2);
                    }
                }

                var offset = 4 * (w*y + x);
                output.set(offset, Std.int(r));
                output.set(offset+1, Std.int(g));
                output.set(offset+2, Std.int(b));
                output.set(offset+3, 255);
            }
        }
        return output;
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
