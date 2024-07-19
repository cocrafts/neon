package neon.platform;

#if js
import neon.platform.web.Renderer.insert as insertFunc;
import neon.platform.web.Renderer.render as renderFunc;
#end

var insert = insertFunc;
var render = renderFunc;
