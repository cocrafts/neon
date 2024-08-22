import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
		print("scene loaded!")
		Main.main()

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
		print("inside!")

		view.backgroundColor = .red

		let label = UILabel()
		label.text = "Hello, Catalyst!!"
		label.textAlignment = .center
		label.frame = view.bounds

		view.addSubview(label)
	}
}
