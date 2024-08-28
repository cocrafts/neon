import UIKit

struct HexColor {
		static func rgb(fromHex hex: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
				var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
				hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

				var rgb: UInt64 = 0
				Scanner(string: hexSanitized).scanHexInt64(&rgb)

				let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
				let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
				let blue = CGFloat(rgb & 0x0000FF) / 255.0

				return (red, green, blue)
		}
}

extension UIColor {
	convenience init(hex: String) {
		let rgb = HexColor.rgb(fromHex: hex)
		self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1.0)
	}
}

extension CGColor {
	static func from(hex: String) -> CGColor {
		let rgb = HexColor.rgb(fromHex: hex)
		return CGColor(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1.0)
	}
}
