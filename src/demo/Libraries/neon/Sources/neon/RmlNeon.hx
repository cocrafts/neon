package neon;

import kha.Framebuffer;
import neon.rml.RenderInterface;

@:headerCode('
#include <RmlUi/Core.h>
#include <RmlUi/Debugger.h>
#include "RmlUiBackend.h"
')
class RmlNeon {
	@:functionCode('Rml::Initialise();')
	public static function initialize():Void {};

	public static function initializeRenderBackend(windowName:String, width:Int, height:Int, allowResize:Bool):Bool {
		return untyped __cpp__("Backend::Initialize({0}, {1}, {2}, {3})", windowName, width, height, allowResize);
	}

	public static function initializeDebugger(context:cpp.RawPointer<neon.rml.Context>):Bool {
		// return untyped __cpp__("Rml::Debugger::Initialise({0})", context);
		return true;
	}

	public static function configureRenderInterface():Void {
		untyped __cpp__("Rml::SetRenderInterface(Backend::GetRenderInterface())");
	}

	public static function getRenderInterface():cpp.RawPointer<RenderInterface> {
		return untyped __cpp__("Backend::GetRenderInterface()");
	}

	public static function setFramebuffer(fb:Framebuffer):Void {
		untyped __cpp__("Backend::SetFramebuffer({0})", fb);
	}

	public static function beginFrame():Void {
		untyped __cpp__("Backend::BeginFrame()", fb);
	}

	public static function presentFrame():Void {
		untyped __cpp__("Backend::PresentFrame()", fb);
	}

	public static function shutdown():Void {
		untyped __cpp__("Rml::Shutdown()");
	};

	public static function createContext(name:String, width:Int, height:Int):cpp.RawPointer<neon.rml.Context> {
		return untyped __cpp__("Rml::CreateContext(name.__s, Rml::Vector2i(width, height))");
	};

	public static function loadFontFace(data:haxe.io.Bytes, family:String, style:Int):Bool {
		untyped __cpp__("Rml::byte* arr = new Rml::byte[data->length]");
		untyped __cpp__("for (int i = 0; i < data->length; i++) {
			arr[i] = data->b->__get(i);
		}");

		return untyped __cpp__("Rml::LoadFontFace(
			Rml::Span<const Rml::byte>(arr, data->length),
			family.__s, static_cast<Rml::Style::FontStyle>(style)
		)");
	};
}

enum FontStyle {
	Normal;
	Italic;
}
