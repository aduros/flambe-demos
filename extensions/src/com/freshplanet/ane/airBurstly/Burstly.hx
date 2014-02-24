package com.freshplanet.ane.airBurstly;

@:native("com.freshplanet.ane.AirBurstly.Burstly")
extern class Burstly extends flash.events.EventDispatcher {
	var logEnabled : Bool;
	var sdkVersion(default,never) : String;
	function new() : Void;
	function cacheInterstitial(?p1 : String) : Void;
	function hideBanner() : Void;
	function init(p1 : String, p2 : String, p3 : String, ?p4 : Array<Dynamic>) : Void;
	function isInterstitialPreCached(?p1 : String) : Bool;
	function setUserInfo(p1 : flash.utils.Object) : Void;
	function showBanner() : Void;
	function showInterstitial(?p1 : String) : Void;
	static var isSupported(default,never) : Bool;
	static function getInstance() : Burstly;
}
