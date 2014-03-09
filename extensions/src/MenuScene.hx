//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;
import flambe.System;
import flambe.animation.AnimatedFloat;
import flambe.display.FillSprite;
import flambe.display.Graphics;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.scene.SlideTransition;
import flambe.util.Value;

class MenuScene
{
    public static function create (ctx :AppContext, title :String, buttons :Array<Dynamic>, ?includeBack :Bool = true)
    {
        if (includeBack) {
            var back :Array<Dynamic> = ["Back", function () {
                ctx.director.popScene(new SlideTransition(0.5).right());
            }];
            buttons = back.concat(buttons);
        }

        var scene = new Entity()
            .add(new FillSprite(0x101010, System.stage.width, System.stage.height));

        var label = new TextSprite(ctx.bigFont, title).setAlign(Center).setXY(System.stage.width/2, PAD);
        scene.addChild(new Entity().add(label));

        var buttonContainer = new Entity()
            .add(new Sprite().setXY(PAD, ctx.bigFont.lineHeight + 2*PAD));
        scene.addChild(buttonContainer);

        var ii = 0;
        while (ii < buttons.length) {
            var y = ii/2;
            var text :String = buttons[ii++];
            var onClick :Void->Void = buttons[ii++];
            var button = createButton(ctx, text, onClick);
            var sprite = button.get(Sprite);
            sprite.setXY(0, (sprite.getNaturalHeight()+PAD) * y);
            buttonContainer.addChild(button);
        }

        return scene;
    }

    private static function createButton (ctx :AppContext, text :String, onClick :Void->Void) :Entity
    {
        var background = new ButtonSprite(System.stage.width - 2*PAD,
            ctx.smallFont.lineHeight + 2*PAD);
        background.pointerDown.connect(function (_) {
            background.selected._ = true;
            System.pointer.up.connect(function (_) {
                background.selected._ = false;
                trace("Clicked button: \""+text+"\"");
                onClick();
            }).once();
        });

        var label = new TextSprite(ctx.smallFont, text)
            .setAlign(Center)
            .disablePointer()
            .setXY(background.getNaturalWidth()/2,
                background.getNaturalHeight()/2 - ctx.smallFont.lineHeight/2);

        var button = new Entity().add(background);
        button.addChild(new Entity().add(label));
        return button;
    }

    private static inline var PAD = 10;
}

// A real simple programmer-art button background
class ButtonSprite extends Sprite
{
    public var width (default, null) :AnimatedFloat;
    public var height (default, null) :AnimatedFloat;
    public var selected (default, null) :Value<Bool>;

    public function new (width :Float, height :Float)
    {
        super();
        this.width = new AnimatedFloat(width);
        this.height = new AnimatedFloat(height);
        this.selected = new Value<Bool>(false);
    }

    override public function draw (g :Graphics)
    {
        var w = width._;
        var h = height._;
        var color = 0xf0f0f0;

        if (selected._) {
            g.fillRect(color, 0, 0, w, h);
        }
        else {
            var thickness = 2;
            g.fillRect(color, 0, 0, w, thickness);
            g.fillRect(color, 0, h-thickness, w, thickness);
            g.fillRect(color, 0, 0, thickness, h);
            g.fillRect(color, w-thickness, 0, thickness, h);
        }
    }

    override public function getNaturalWidth () :Float
    {
        return width._;
    }

    override public function getNaturalHeight () :Float
    {
        return height._;
    }

    override public function onUpdate (dt :Float)
    {
        super.onUpdate(dt);
        width.update(dt);
        height.update(dt);
    }
}
