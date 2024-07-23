package ssr;

import haxe.Json;
import sys.io.File;
import neon.core.Common;
import neon.runtime.Lambda;
import site.components.App;

class Main {
	private static var template:String;

	static function main() {
		if (template == null) {
			template = File.getContent('index.html');
		}

		var markup = neon.platform.ssr.Renderer.renderToString(template, App, {});
		trace(markup, "<--");

		// new Lambda().start(lambdaHandler);
	}

	static function lambdaHandler(event:Dynamic, context:LambdaContext):Dynamic {
		return {
			statusCode: 200,
			body: neon.platform.ssr.Renderer.renderToString(template, App, {}),
		};
	}
}
