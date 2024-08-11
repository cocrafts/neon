import ProjectDescription

let project = Project(
	name: "Hype",
	packages: [
		.package(path: "../lib/yoga")
		// .package(path: "../out/app/libMain.a")
		// .package(path: "/Users/le/Sources/haxe/lib/hxcpp/4,3,2")
		// .package(path: "Packages/Neon")
	],
	settings: .settings(
		base: [
			// "OTHER_CFLAGS": "-std=c++17", // Specify any other CFLAGS you want
			// "CLANG_CXX_LANGUAGE_STANDARD": "c++17", // or "c++17" for C++17
			"CLANG_CXX_LIBRARY": "libc++", // Use the LLVM standard C++ library
			"CLANG_CXX_LANGUAGE_STANDARD": "c++20",
			"SWIFT_OBJC_BRIDGING_HEADER": "Hype/Sources/Bridging-Header.h",
			"SWIFT_OBJC_INTEROP_MODE": "objcxx",
			"HEADER_SEARCH_PATHS": [
				"/Users/le/Metacraft/neon/out/app/include",
				"/Users/le/Sources/haxe/lib/hxcpp/4,3,2/include",
				"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include"
			]
		]
	),
	targets: [
		.target(
			name: "Hype",
			destinations: .macOS,
			product: .app,
			bundleId: "io.stormgate.Hype",
			deploymentTargets: .macOS("14.2"),
			infoPlist: .extendingDefault(with: [
				"CFBundleDisplayName": "Hype",
				"CFBundleIdentifier": "io.stormgate.hype"
			]),
			// sources: ["Hype/Sources/**", "Hype/Haxe/**"],
			sources: ["Hype/Sources/**"],
			resources: ["Hype/Resources/**"],
			headers: Headers.headers(
				// public: ["Hype/Haxe/binding/**"],
				project: ["Hype/Sources/**/*.h"]
			),
			dependencies: [
				.package(product: "yoga")
				// .package(product: "NeonApp")
			]
		),
		.target(
			name: "HypeTests",
			destinations: .macOS,
			product: .unitTests,
			bundleId: "io.tuist.HypeTests",
			infoPlist: .default,
			sources: ["Hype/Tests/**"],
			resources: [],
			dependencies: [.target(name: "Hype")]
		)
	]
)
