#include <RmlUi/Core.h>
#include <hxinc/kha/Assets.h>
#include <hxinc/kha/Framebuffer.h>
#include <hxinc/kha/SystemImpl.h>
#include <hxinc/kha/_Color/Color_Impl_.h>
#include <hxinc/kha/graphics2/Graphics.h>
#include <hxinc/haxe/io/Bytes.h>

namespace Neon {
class RmlKhaRender : public Rml::RenderInterface {
public:
  RmlKhaRender();
  ~RmlKhaRender();

  void SetViewport(int viewport_width, int viewport_height);
  void BeginFrame();
  void EndFrame();
  void Clear();

  Rml::CompiledGeometryHandle
  CompileGeometry(Rml::Span<const Rml::Vertex> vertices,
                  Rml::Span<const int> indices) override;
  void RenderGeometry(Rml::CompiledGeometryHandle handle,
                      Rml::Vector2f translation,
                      Rml::TextureHandle texture) override;
  void ReleaseGeometry(Rml::CompiledGeometryHandle handle) override;

  Rml::TextureHandle LoadTexture(Rml::Vector2i &texture_dimensions,
                                 const Rml::String &source) override;
  Rml::TextureHandle GenerateTexture(Rml::Span<const Rml::byte> source_data,
                                     Rml::Vector2i source_dimensions) override;
  void ReleaseTexture(Rml::TextureHandle texture_handle) override;

  void EnableScissorRegion(bool enable) override;
  void SetScissorRegion(Rml::Rectanglei region) override;

  void EnableClipMask(bool enable) override;
  void RenderToClipMask(Rml::ClipMaskOperation operation,
                        Rml::CompiledGeometryHandle geometry,
                        Rml::Vector2f translation) override;

  void SetTransform(const Rml::Matrix4f *transform) override;
    
  template<typename T>
  static int convertColor(const T &color);
  static ::haxe::io::Bytes convertSpanToBytes(const Rml::Span<const Rml::byte> &source);

private:
  struct GeometryView {
    Rml::Span<const Rml::Vertex> vertices;
    Rml::Span<const int> indices;
  };

  int viewport_width = 0;
  int viewport_height = 0;
  bool transform_enabled = false;
};
} // namespace Neon

namespace RmlKha {
bool Initialize(Rml::String *out_message = nullptr);
void Shutdown();
} // namespace RmlKha
