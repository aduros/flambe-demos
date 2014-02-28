# Shmup demo

This is a prototype of a minimal but complete game. It shows how to use
a preloader, localization, scenes, animation, text, sound effects, and
more. It might make a good foundation for a real game project.

Try it out in [Flash], [HTML5] or [Android].

## Architecture overview

`shmup.Main` is the entry point to the game. Then it loads the bootstrap
pack, which contains assets only used by the preloader. Once that's
loaded, it can actually show the preloader and load the main bulk of the
game. All localized assets (just a messages.ini for localized text in
this demo) are separated into a "locale" pack.

Once the game is loaded, a `ShmupContext` is created which contains all
the game state that gets passed around. The scenes are split up into
different classes, each with a static `create()` function.

`LevelModel` oversees the actual game logic. Enemy planes have different
behaviors, and are created by mix-and-matching the different components
in the `shmup.ai` package.

[Flash]: https://aduros.com/flambe/demos/shmup/?flambe=flash
[HTML5]: https://aduros.com/flambe/demos/shmup/?flambe=html
[Android]: https://aduros.com/flambe/demos/shmup/main-android.apk
