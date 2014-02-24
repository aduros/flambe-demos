package com.freshplanet.ane.airBurstly;

@:native("com.freshplanet.ane.AirBurstly.BurstlyEvent")
extern class BurstlyEvent extends flash.events.Event {
	function new(p1 : String, p2 : Bool = false, p3 : Bool = false) : Void;
	static var INTERSTITIAL_DID_FAIL : String;
	static var INTERSTITIAL_WAS_CLICKED : String;
	static var INTERSTITIAL_WILL_APPEAR : String;
	static var INTERSTITIAL_WILL_DISMISS : String;
}
