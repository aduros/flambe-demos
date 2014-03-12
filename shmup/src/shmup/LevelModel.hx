//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package shmup;

import flambe.Component;
import flambe.Entity;
import flambe.SpeedAdjuster;
import flambe.System;
import flambe.animation.Ease;
import flambe.display.ImageSprite;
import flambe.display.PatternSprite;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Value;

import shmup.ai.ChargeAtPlayer;
import shmup.ai.MoveStraight;
import shmup.ai.ShootAtPlayer;
import shmup.ai.ShootStraight;

class LevelModel extends Component
{
    public static inline var PLAYER_SPEED = 1000;
    public static inline var BULLET_SPEED = 500;

    /** The player's Entity. */
    public var player (default, null) :Entity;

    /** The current score. */
    public var score (default, null) :Value<Int>;

    public function new (ctx :ShmupContext)
    {
        _ctx = ctx;
        _enemies = [];
        score = new Value<Int>(0);
    }

    override public function onAdded ()
    {
        _worldLayer = new Entity();
        owner.addChild(_worldLayer);

        // Add a scrolling ocean background
        var background = new PatternSprite(_ctx.pack.getTexture("Water"),
            System.stage.width, System.stage.height + 32);
        _worldLayer.addChild(new Entity().add(background).add(new BackgroundScroller(100)));

        _worldLayer.addChild(_cloudLayer = new Entity());
        _worldLayer.addChild(_planeLayer = new Entity());
        _worldLayer.addChild(_bulletLayer = new Entity());
        _worldLayer.addChild(_explosionLayer = new Entity());

        // Create the player's plane
        var plane = new Plane(_ctx, "aircraft_1e", 5, 3);
        plane.destroyed.connect(function () {
            // When the player dies, show an explosion
            var sprite = player.get(Sprite);
            explode(sprite.x._, sprite.y._);

            // Adjust the speed of the world for a dramatic slow motion effect
            var worldSpeed = new SpeedAdjuster(0.5);
            _worldLayer.add(worldSpeed);

            // Then show the game over prompt after a moment
            var script = new Script();
            script.run(new Sequence([
                new AnimateTo(worldSpeed.scale, 0, 1.5),
                new CallFunction(function () {
                    _ctx.showPrompt(_ctx.messages.get("game_over", [score._]), [
                        "Replay", function () {
                            _ctx.enterPlayingScene(false);
                        },
                        "Home", function () {
                            _ctx.director.popScene();
                            _ctx.enterHomeScene();
                        },
                        "Tweet", function () {
                            System.web.openBrowser("https://twitter.com/share" +
                                "?text="+_ctx.messages.get("tweet", [score._]));
                        },
                    ]);
                }),
            ]));
            owner.add(script);
        });

        player = new Entity().add(plane);
        _planeLayer.addChild(player);
        _friendlies = [player];

        // Have the player shoot a bullet every 0.3 seconds
        var playerScript = new Script();
        playerScript.run(new Repeat(new Sequence([
            new Delay(0.3),
            new CallFunction(function () {
                var sprite = player.get(Sprite);
                shoot(sprite.x._, sprite.y._, 0, -1.5*LevelModel.BULLET_SPEED, _enemies);
            }),
        ])));
        player.add(playerScript);

        // Start the player near the bottom of the screen
        player.get(Sprite).setXY(System.stage.width/2, 0.8*System.stage.height);

        var worldScript = new Script();
        _worldLayer.add(worldScript);

        // Repeatedly spawn new enemy planes
        worldScript.run(new Repeat(new Sequence([
            new Delay(0.8),
            new CallFunction(function () {
                var enemy = new Entity().add(new Plane(_ctx, "aircraft_1c", 30, 2));

                var points = 0;
                var rand = Math.random();
                if (rand < 0.3) {
                    // A quick enemy that strafes from one side of the screen to the other
                    var left = Math.random() < 0.5;
                    var speed = Math.random()*100 + 150;
                    enemy
                        .add(new MoveStraight(_ctx, left ? -speed : speed, 0))
                        .add(new ShootStraight(_ctx, 0.2).single())
                        .add(new Plane(_ctx, "aircraft_1c", 30, 1));
                    var sprite = enemy.get(Sprite);
                    sprite.setXY(left ? System.stage.width : 0, Math.random()*200+100);
                    points = 10;

                } else if (rand < 0.6) {
                    // An enemy that follows the player and shoots directly at them
                    enemy
                        .add(new ChargeAtPlayer(_ctx, 50, 150))
                        .add(new ShootAtPlayer(_ctx, 1))
                        .add(new Plane(_ctx, "aircraft_2c", 40, 2));
                    var sprite = enemy.get(Sprite);
                    sprite.setXY(Math.random()*System.stage.width, -30);
                    points = 4;

                } else {
                    // A slow bomber that shoots a large spread of bullets
                    enemy
                        .add(new MoveStraight(_ctx, Math.random()*100-50, 200))
                        .add(new ShootStraight(_ctx, 1).multi(45, 5))
                        .add(new Plane(_ctx, "aircraft_3", 50, 3));
                    var sprite = enemy.get(Sprite);
                    sprite.setXY(Math.random()*System.stage.width, -30);
                    points = 4;
                }

                var sprite = enemy.get(Sprite);
                enemy.get(Plane).destroyed.connect(function () {
                    explode(sprite.x._, sprite.y._);
                    score._ += points;
                });

                _planeLayer.addChild(enemy);
                _enemies.push(enemy);
            }),
        ])));

        // Repeatedly spawn a few clouds in the background for eye candy
        worldScript.run(new Repeat(new Sequence([
            new Delay(1.5),
            new CallFunction(function () {
                var cloud = new ImageSprite(_ctx.pack.getTexture("Cloud"))
                    .centerAnchor().setAlpha(0.5);
                cloud.setXY(Math.random() * System.stage.width, -cloud.getNaturalHeight()/2);
                worldScript.run(new Sequence([
                    new AnimateTo(cloud.y, System.stage.height+cloud.getNaturalHeight()/2, 10+6*Math.random()),
                    new CallFunction(cloud.dispose),
                ]));
                _cloudLayer.addChild(new Entity().add(cloud));
            }),
        ])));
    }

    /** Shoot a bullet that will collide with the given targets. */
    public function shoot (x :Float, y :Float, velX :Float, velY :Float, targets :Array<Entity>)
    {
        var bullet = new Bullet(_ctx, velX, velY, targets);
        var sprite = new ImageSprite(_ctx.pack.getTexture("Bullet")).setXY(x, y).centerAnchor();

        sprite.rotation._ = FMath.toDegrees(Math.atan2(velY, velX)) + 90;
        _bulletLayer.addChild(new Entity().add(bullet).add(sprite));
    }

    public function shootFromEnemy (enemy :Entity, velX :Float, velY :Float)
    {
        var sprite = enemy.get(Sprite);
        shoot(sprite.x._, sprite.y._, velX, velY, _friendlies);
    }

    /** Show an explosion effect. */
    public function explode (x :Float, y :Float)
    {
        var movie = _ctx.lib.createMovie("explosion");
        movie.looped.connect(function () {
            // Only play it once before disposing the entire entity
            movie.owner.dispose();
        });
        movie.setXY(x, y);
        _explosionLayer.addChild(new Entity().add(movie));

        // Also play a sound
        _ctx.pack.getSound("sounds/Explode").play();
    }

    override public function onUpdate (dt :Float)
    {
        var pointerX = System.pointer.x;
        var pointerY = System.pointer.y;

        // If the player is using a touch screen, offset a bit so that the plane isn't obscurred by
        // their finger
        if (System.touch.supported) {
            pointerY -= 80;
        }

        // Move towards the pointer position at a fixed speed
        var sprite = player.get(Sprite);
        if (sprite != null) {
            var dx = pointerX - sprite.x._;
            var dy = pointerY - sprite.y._;
            var distance = Math.sqrt(dx*dx + dy*dy);

            var travel = PLAYER_SPEED * dt;
            if (travel < distance) {
                sprite.x._ += travel * dx/distance;
                sprite.y._ += travel * dy/distance;
            } else {
                sprite.x._ = pointerX;
                sprite.y._ = pointerY;
            }
        }

        // Remove offscreen enemies
        var ii = 0;
        while (ii < _enemies.length) {
            var enemy = _enemies[ii];
            var sprite = enemy.get(Sprite);
            var radius = enemy.get(Plane).radius;

            if (sprite.x._ < -radius || sprite.x._ > System.stage.width+radius ||
                sprite.y._ < -radius || sprite.y._ > System.stage.height+radius) {

                _enemies.splice(ii, 1);
                enemy.dispose();
            } else {
                ++ii;
            }
        }
    }

    private var _ctx :ShmupContext;

    private var _worldLayer :Entity;
    private var _cloudLayer :Entity;
    private var _planeLayer :Entity;
    private var _bulletLayer :Entity;
    private var _explosionLayer :Entity;

    private var _enemies :Array<Entity>;
    private var _friendlies :Array<Entity>;
}
