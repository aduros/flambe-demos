# Extensions demo

This demonstrates using AIR native extensions (ANE). To build with an
ANE, place it in your project's libs/ directory. You can also stick .swc
and .swf files in there for pure AS3 libraries.

This demo uses these extensions:

- [Flurry] for analytics. Requires adding a couple permissions to the
  Android manifest.

- [Vibration]. Make sure to add the Android VIBRATE permission.

- [Google Analytics].

- [Appirater].

- [Chartboost]. (Not currently working?)

- [Admob]. (Not currently working?)

- [Playhaven]. (Not currently working?)

Try it out on [Android].

## Dealing with capitalized packages

When working with libraries written in AS3, you may run into package
names that are capitilized, which is not allowed in Haxe. One way around
this is to generate externs from the .swc/.ane, then edit them and use
@:native. For example:

1. `haxe --gen-hx-classes -swf-lib libs/AirBurstly.ane -swf out.swf
--no-output`

2. Copy the generated `hxclasses/com/freshplanet/ane/AirBurstly/` to
`src/com/freshplanet/airBurstly/`.

3. Edit the new files in src/ to the lower-cased package, and add
@:native to each class to point to the original, capitalized package.

The Burstly ANE uses a capitalized package, and this demo contains the
result of these three steps.

[Android]: https://aduros.com/flambe/demos/extensions/main-android.apk

[Burstly]: https://github.com/freshplanet/ANE-Burstly
[Flurry]: https://github.com/freshplanet/ANE-Flurry
[Vibration]: https://www.adobe.com/devnet/air/native-extensions-for-air/extensions/vibration.html
[Google Analytics]: https://github.com/alebianco/ANE-Google-Analytics
[Admob]: https://github.com/heitara/Admob-ANE
[Chartboost]: https://github.com/freshplanet/ANE-Chartboost
[Appirater]: https://code.google.com/p/appirater-ane/
[Playhaven]: https://github.com/playhaven/sdk-air
