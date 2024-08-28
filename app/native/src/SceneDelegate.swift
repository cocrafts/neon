import UIKit
import CxxStdlib

var catalystRootView: UIView = UIView()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
		if let windowScene = scene as? UIWindowScene {
			window = UIWindow(windowScene: windowScene)
			let viewController = ViewController()
			window?.rootViewController = viewController
			window?.makeKeyAndVisible()
		}
	}
}

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .red
		catalystRootView = view
		Main.main()
	}
}

public func getRootElement() -> Element {
	return Element.init(view: catalystRootView)
}
