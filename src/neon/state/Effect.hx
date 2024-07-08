package neon.state;

class Effect {
	private var effect:Void->Void;
	private var dependencies:Array<Signal<Dynamic>>;

	public function new(effect:Void->Void) {
		this.effect = effect;
		this.dependencies = [];
		this.run();
	}

	public function run():Void {
		this.cleanup();
		Signal.currentEffect = this;
		this.effect();
		Signal.currentEffect = null;
	}

	public function registerDependency<T>(signal:Signal<T>):Void {
		signal.subscribe(cast this.run);
		this.dependencies.push(signal);
	}

	private function cleanup():Void {
		for (dependency in this.dependencies) {
			dependency.unsubscribe(cast this.run);
		}
		this.dependencies = [];
	}
}
