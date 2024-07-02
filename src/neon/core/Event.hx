package neon.core;

import haxe.ds.StringMap;

class CallbackManager {
	private static var callbackMap:StringMap<Dynamic->Void> = new StringMap();
	private static var idCounter:Int = 0;

	public static function registerCallback(callback:Dynamic->Void) {
		var id = 'cb_${idCounter++}';
		callbackMap.set(id, callback);
		return id;
	}

	public static function invokeCallback(id:String, args:Dynamic):Void {
		var callback = callbackMap.get(id);
		if (callback != null) {
			callback(args);
		}
	}
}
