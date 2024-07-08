package neon.state;

class Signal<T> {
	private var value:T;
	private var dependents:Array<Dynamic->Void>;

	public static var currentEffect:Effect = null;

	public function new(initialValue:T) {
		this.value = initialValue;
		this.dependents = [];
	}

	public function get():T {
		if (Signal.currentEffect != null) {
			Signal.currentEffect.registerDependency(this);
		}

		return this.value;
	}

	public function set(next:T):Void {
		if (this.value != next) {
			this.value = next;
			this.trigger();
		}
	}

	public function subscribe(callback:Dynamic->Void):() -> Void {
		this.dependents.push(callback);

		return function() {
			this.dependents.remove(callback);
		};
	}

	public function unsubscribe(callback:Dynamic->Void):Void {
		this.dependents.remove(callback);
	}

	private function trigger():Void {
		for (callback in dependents) {
			callback(this.value);
		}
	}
}
