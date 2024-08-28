class EffectManager {
	static let shared = EffectManager()
	var currentEffect: (() -> Void)?

	private init() {}
}

class NeonSignal<T: Equatable> {
	private var value: T
	private var effects: [() -> Void] = []

	init(_ initialValue: T) {
		value = initialValue
	}

	func get() -> T {
		if let effect = EffectManager.shared.currentEffect {
			effects.append(effect)
		}

		return value
	}

	func set(_ next: T) {
		if value != next {
			value = next
			trigger()
		}
	}

	private func trigger() {
		for effect in effects {
			effect()
		}
	}
}

public func catalystRender() {
	print("render!")
}
