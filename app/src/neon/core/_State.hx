package neon.core;

@native("Neon::EffectManager") extern class EffectManager {
	public static var shared:EffectManager;
	public static var currentEffect:Void->Void;
}

@native("neon::NeonSignal") extern class Signal<T> {
	public function new(initialValue:T);
	public static function create<T>(initialValue:T):Signal<T>;
}

// function createSignal<T>(initialValue:T):Signal<T> {
// 	return null;
// 	// return new Signal(initialValue);
// }
// function createEffect(effect:Void->Void):Void {
// 	var previousEffect = EffectManager.currentEffect;
// 	EffectManager.currentEffect = effect;
// 	effect();
// 	EffectManager.currentEffect = previousEffect;
// }
