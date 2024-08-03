#include <RmlUi/Core/Input.h>
#include <RmlUi/Core/RenderInterface.h>
#include <RmlUi/Core/SystemInterface.h>
#include <RmlUi/Core/Types.h>
#include <hxinc/kha/Framebuffer.h>
#include <hxinc/kha/System.h>

using KeyDownCallback = bool (*)(Rml::Context *context,
                                 Rml::Input::KeyIdentifier key,
                                 int key_modifier, float native_dp_ratio,
                                 bool priority);

namespace Backend {
bool Initialize(const char *window_name, int width, int height,
                bool allow_resize);
void Shutdown();

Rml::SystemInterface *GetSystemInterface();
Rml::RenderInterface *GetRenderInterface();

bool ProcessEvents(Rml::Context *context,
                   KeyDownCallback key_down_callback = nullptr,
                   bool power_save = false);

void RequestExit();
void BeginFrame();
void SetFramebuffer(::kha::Framebuffer fb); // passing Kha's Framebuffer
void PresentFrame();
} // namespace Backend
