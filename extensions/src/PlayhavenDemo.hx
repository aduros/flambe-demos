//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

import flambe.Entity;

import com.playhaven.PlayHaven;

// https://github.com/playhaven/sdk-air
class PlayhavenDemo extends ExtensionDemo
{
    public function new ()
    {
        super("Playhaven / Kontagent");
    }

    override public function init ()
    {
#if android
         PlayHaven.create("9e7003dc027d494a8caf0d544c6afd82", "bb7c1a4795f649e39a1bded0ffe4164d");
#elseif ios
         PlayHaven.create("de0c469296eb4e8b9b17435be2da5ee6", "970acfcd3b974198845c671ad97c0487");
#end
    }

    override public function createScene (ctx :AppContext) :Entity
    {
        var placements = [
            "main_menu",
            "pause_menu",
            "store_open",
            "level_complete",
            "level_up",
            "level_failed",
            "achievement_unlocked",
            "game_launch",
        ];

        var buttons :Array<Dynamic> = [];
        for (placement in placements) {
            buttons.push("Show "+placement);
            buttons.push(function () {
                PlayHaven.playhaven.sendContentRequest(placement);
            });
        }

        return MenuScene.create(ctx, name, buttons);
    }
}
