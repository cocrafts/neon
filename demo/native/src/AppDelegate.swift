import AppKit
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	override init() {
		super.init()
		print("wassup")
		// conceptual proof of life init override
		// wait until applicationDidFinishLaunching , specially for UI
	}

	var window: NSWindow!
	var mainWindowController: NSWindowController!

	func applicationDidFinishLaunching(_: Notification) {
		print("yo! I'm alive")
		mainWindowController = MainWindowController()
		mainWindowController?.showWindow(self)
	}
}

class MainWindowController: NSWindowController {
	init() {
		let window = NSWindow(contentViewController: MyViewController())
		super.init(window: window)

		window.title = "My Window Title"
		window.makeKeyAndOrderFront(nil)
		window.center()
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class MyViewController: NSViewController {
	override func loadView() {
		view = NSView()
		view.frame = NSRect(x: 0, y: 0, width: 600, height: 400)
	}
}
