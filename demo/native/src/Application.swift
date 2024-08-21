import Cocoa

class Application: NSApplication {
	let strongDelegate = AppDelegate()

	override init() {
		super.init()
		delegate = strongDelegate
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
