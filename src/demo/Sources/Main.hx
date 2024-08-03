package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import neon.RmlNeon.FontStyle;

var win:kha.System.SystemOptions = {
	title: "Project",
	width: 1024,
	height: 768
};

var template = '
<rml>
<head>
	<style>
		body {
				display: flex;
				width: 100%;
				height: 100%;
				background-color: green;
				color: white;
				font-size: 32px; 
				font-family: Rubik;
		}
		.sub {
			position: absolute;
			top: 50px;
			left: 50px;
			width: 500px;
			height: 500px;
			border-radius: 18px;
			overflow: hidden;
			background-color: #FFFFFF;
			font-size: 12px;
			color: black;
			font-family: SankofaDisplay-Regular;
		}
	</style>
</head>
<body>
	<div id="main" style="background-color: blue; flex: 1;">
		<p>Hello, world!</p>
	</div>
	<div id="main" style="background-color: red;">
		<p>From RmlUI!</p>
	</div>
	<div class="sub">
		<div>hello </div>
		<div style="font-family: Rubik;">hello</div>
	</div>
</body>
</rml>';

@:headerCode('#include <RmlUi/Core.h>')
class Main {
	static var context:cpp.RawPointer<neon.rml.Context>;

	static function update():Void {}

	static function render(frames:Array<Framebuffer>):Void {
		final fb = frames[0];
		final g2 = fb.g2;

		neon.RmlNeon.setFramebuffer(fb);
		untyped __cpp__("{0}->Update()", context);
		neon.RmlNeon.beginFrame();
		untyped __cpp__("{0}->Render()", context);
		neon.RmlNeon.presentFrame();
	}

	public static function main() {
		System.start(win, function(_) {
			/*  1. Initialize Window/App
			 *  2. Initialize Render Backend
			 *  3. Get and Set RenderInterface
			 *  4. Initialize RmlUi Engine
			 *  5. Create RmlUi Context
			 *  6. Initialize Debugger (optional)
			 *  7. Load Fonts (optional)
			 *  8. Load and show the document
			 *  9. Enter the rendering loop
			 * 10. If exit the rendering loop, then call Shutdown initialized instances for memory cleanup
			 */

			// 2. Initialize Render Backend
			neon.RmlNeon.initializeRenderBackend(win.title, win.width, win.height, true);
			// 3. Get and Set RenderInterface
			neon.RmlNeon.configureRenderInterface();
			// 4.Initialize RmlUi Engine
			neon.RmlNeon.initialize();
			// 5. Create RmlUi Context
			context = neon.RmlNeon.createContext("main", win.width, win.height);
			// 6. Initialize Debugger
			neon.RmlNeon.initializeDebugger(context);

			Assets.loadBlob("Rubik", function(blob) {
				Assets.loadBlob("SankofaDisplay", function(sankoBlob) {
					var rubikBytes = blob.toBytes();
					var sankoBytes = blob.toBytes();
					// 7. Load Font from Kha Assets module
					var loaded = neon.RmlNeon.loadFontFace(rubikBytes, "Rubik", 0);
					var loaded = neon.RmlNeon.loadFontFace(sankoBytes, "SankofaDisplay-Regular", 0);
					// 8. Load and show the document
					var document:cpp.RawPointer<neon.rml.ElementDocument> = untyped __cpp__("{0}->LoadDocumentFromMemory({1}.__s)", context, template);
					untyped __cpp__("{0}->Show()", document);

					Scheduler.addTimeTask(function() {
						update();
					}, 0, 1 / 60);

					System.notifyOnFrames(function(frames) {
						render(frames);
					});
				});
			});
		});
	}
}
