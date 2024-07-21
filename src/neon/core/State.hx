package neon.core;

class Signal<T> {
	private var value:T;
	private var effects:Array<Void->Void>;

	public static var currentEffect:Void->Void = null;

	public function new(initialValue:T) {
		this.value = initialValue;
		this.effects = [];
	}

	public function get():T {
		if (Signal.currentEffect != null) {
			this.effects.push(Signal.currentEffect);
		}

		return this.value;
	}

	public function set(next:T):Void {
		if (this.value != next) {
			this.value = next;
			this.trigger();
		}
	}

	private function trigger():Void {
		for (effect in effects) {
			effect();
		}
	}

	public function subscribe(callback:Void->Void):() -> Void {
		this.effects.push(callback);

		return function() {
			this.effects.remove(callback);
		};
	}

	public function unsubscribe(callback:Void->Void):Void {
		this.effects.remove(callback);
	}
}

function createSignal<T>(initialValue:T):Signal<T> {
	return new Signal(initialValue);
}

function createEffect(effect:Void->Void):Void {
	var previousEffect = Signal.currentEffect;
	Signal.currentEffect = effect;
	effect();
	Signal.currentEffect = previousEffect;
}
