#include "RmlKhaRender.h"
#include "RmlUiBackend.h"
#include <RmlUi/Core/RenderInterface.h>
#include <hxinc/kha/Image.h>
#include <hxinc/kha/math/FastMatrix4.h>
#include <iostream>

struct BackendData {
  BackendData() {}
  Neon::RmlKhaRender render_interface;
  ::kha::Framebuffer fb;
  Rml::Rectanglei last_cisor_region;
  bool running = true;
};

static Rml::UniquePtr<BackendData> data;

/* Rendering Interface
 * Provide interface that get called by the Backend impl right bellow
 * --------------------------------------------------------------------- */

Neon::RmlKhaRender::RmlKhaRender() {
  std::cout << "intiated Renderer!!!!" << std::endl;
}

Neon::RmlKhaRender::~RmlKhaRender() {
  std::cout << "deinit Renderer!" << std::endl;
}

void Neon::RmlKhaRender::SetViewport(int in_viewport_width,
                                     int in_viewport_height) {
  viewport_width = in_viewport_width;
  viewport_height = in_viewport_height;
}

void Neon::RmlKhaRender::BeginFrame() {}
void Neon::RmlKhaRender::EndFrame() {}
void Neon::RmlKhaRender::Clear() {}

Rml::CompiledGeometryHandle
Neon::RmlKhaRender::CompileGeometry(Rml::Span<const Rml::Vertex> vertices,
                                    Rml::Span<const int> indices) {
  GeometryView *geometry = new GeometryView{vertices, indices};
  return reinterpret_cast<Rml::CompiledGeometryHandle>(geometry);
}

void Neon::RmlKhaRender::RenderGeometry(Rml::CompiledGeometryHandle geometry_handle,
                                        Rml::Vector2f translation,
                                        Rml::TextureHandle texture_handle) {
  const GeometryView *geometry = reinterpret_cast<GeometryView *>(geometry_handle);
  const Rml::Vertex *vertices = geometry->vertices.data();
  const int *indices = geometry->indices.data();
  const int num_indices = static_cast<int>(geometry->indices.size());
  auto g2 = data->fb->get_g2();
    
    kha::Image* texture = nullptr;
        if (texture_handle) {
            texture = reinterpret_cast<kha::Image*>(texture_handle);
        }
    int image_width = texture ? texture->GetPtr()->get_width() : 0;
    int image_height = texture ? texture->GetPtr()->get_height() : 0;
    auto tag = texture_handle ? "texture" : "geom";
    std::cout << tag << image_width << ":" << image_height << std::endl;
    
  g2->pushTranslation(translation.x, translation.y);

  for (int i = 0; i < num_indices; i += 3) {
    int index0 = indices[i];
    int index1 = indices[i + 1];
    int index2 = indices[i + 2];

    const auto &v0 = vertices[index0];
    const auto &v1 = vertices[index1];
    const auto &v2 = vertices[index2];

    // Calculate final positions including translation
    float x0 = v0.position.x;
    float y0 = v0.position.y;
    float x1 = v1.position.x;
    float y1 = v1.position.y;
    float x2 = v2.position.x;
    float y2 = v2.position.y;

    g2->set_color(Neon::RmlKhaRender::convertColor(v0.colour));
      
//      if (texture) {
//          float u0 = std::clamp(v0.tex_coord.x, 0.0f, 1.0f) * image_width;
//          float v0_coord = std::clamp(v0.tex_coord.y, 0.0f, 1.0f) * image_height;
//          float u1 = std::clamp(v1.tex_coord.x, 0.0f, 1.0f) * image_width;
//          float v1_coord = std::clamp(v1.tex_coord.y, 0.0f, 1.0f) * image_height;
//          float u2 = std::clamp(v2.tex_coord.x, 0.0f, 1.0f) * image_width;
//          float v2_coord = std::clamp(v2.tex_coord.y, 0.0f, 1.0f) * image_height;
//
//          g2->drawScaledSubImage(*texture, u0, v0_coord, (u1 - u0), (v1_coord - v0_coord), x0, y0, (x1 - x0), (y1 - y0));
//          g2->drawScaledSubImage(*texture, u1, v1_coord, (u2 - u1), (v2_coord - v1_coord), x1, y1, (x2 - x1), (y2 - y1));
//          g2->drawScaledSubImage(*texture, u2, v2_coord, (u0 - u2), (v0_coord - v2_coord), x2, y2, (x0 - x2), (y0 - y2));
//      } else {
//          // Render the triangle using fillTriangle if no texture is present
//          g2->fillTriangle(x0, y0, x1, y1, x2, y2);
//      }
      
      g2->fillTriangle(x0, y0, x1, y1, x2, y2);
  }
    
  g2->popTransformation();

  if (texture) {
    //        g2->set
  }
}

void Neon::RmlKhaRender::ReleaseGeometry(Rml::CompiledGeometryHandle handle) {
  delete reinterpret_cast<GeometryView *>(handle);
}

void Neon::RmlKhaRender::EnableClipMask(bool enable) {
  Neon::RmlKhaRender::EnableScissorRegion(enable);
}

void Neon::RmlKhaRender::RenderToClipMask(Rml::ClipMaskOperation operation,
                                          Rml::CompiledGeometryHandle geometry,
                                          Rml::Vector2f translation) {
  std::cout << "render to clip mask" << std::endl;
  const GeometryView *geom = reinterpret_cast<GeometryView *>(geometry);
  const Rml::Vertex *vertices = geom->vertices.data();
  const int *indices = geom->indices.data();
  int num_indices = static_cast<int>(geom->indices.size());
}

Rml::TextureHandle
Neon::RmlKhaRender::LoadTexture(Rml::Vector2i &texture_dimensions,
                                const Rml::String &source) {
  std::cout << "loading texture" << std::endl;
  return 0;
}

Rml::TextureHandle
Neon::RmlKhaRender::GenerateTexture(Rml::Span<const Rml::byte> source_data,
                                    Rml::Vector2i source_dimensions) {
  if (source_data.empty() || source_dimensions.x <= 0 ||
      source_dimensions.y <= 0) {
    std::cerr << "Invalid source data or dimensions for texture generation."
              << std::endl;
    return 0;
  }

  int width = source_dimensions.x;
  int height = source_dimensions.y;
  int num_pixels = width * height;
  int bytes_per_pixel = 4; // Assuming RGBA format

  if (source_data.size() != num_pixels * bytes_per_pixel) {
    std::cerr << "Source data size does not match expected size." << std::endl;
    return 0;
  }

  auto bytes = Neon::RmlKhaRender::convertSpanToBytes(source_data);
  auto img = kha::Image_obj::fromBytes(bytes, width, height, 0, true, true);

  return reinterpret_cast<Rml::TextureHandle>(img.GetPtr());
}

void Neon::RmlKhaRender::ReleaseTexture(Rml::TextureHandle texture_handle) {
  std::cout << "releasing texture" << std::endl;
}

void Neon::RmlKhaRender::EnableScissorRegion(bool enable) {
  if (enable) {
    Neon::RmlKhaRender::SetScissorRegion(data->last_cisor_region);
  } else {
    data->fb->get_g2()->disableScissor();
  }
}

void Neon::RmlKhaRender::SetScissorRegion(Rml::Rectanglei region) {
  data->last_cisor_region = region;
  data->fb->get_g2()->scissor(region.Left(), region.Top(), region.Width(),
                              region.Height());
}

void Neon::RmlKhaRender::SetTransform(const Rml::Matrix4f *transform) {
  auto g2 = data->fb->get_g2();
  if (transform) {
    // Extract translation components
    const Rml::Vector4f &col0 = (*transform)[0];
    const Rml::Vector4f &col1 = (*transform)[1];
    const Rml::Vector4f &col2 = (*transform)[2];
    const Rml::Vector4f &col3 = (*transform)[3];

    float tx = col3.x;
    float ty = col3.y;
    float tz = col3.z;

    // Extract scale components (assuming uniform scaling)
    float sx = std::sqrt(col0.x * col0.x + col0.y * col0.y + col0.z * col0.z);
    float sy = std::sqrt(col1.x * col1.x + col1.y * col1.y + col1.z * col1.z);

    // Extract rotation components if needed (not directly handled by pushTran//
    // Use translation method to apply transformation
    std::cout << sx << ":" << sy << std::endl;
    g2->pushTranslation(tx, ty);

    // If other transformations are needed, implement custom matrix handling or
    // vertex manipulation
  } else {
    // Reset to default state if no transformation
    g2->popTransformation(); // Ensure to pop any transformations set
  }
}

template <typename T> int Neon::RmlKhaRender::convertColor(const T &color) {
  return kha::_Color::Color_Impl__obj::fromBytes(color.red, color.green,
                                                 color.blue, color.alpha);
}

template int Neon::RmlKhaRender::convertColor(const Rml::Colourb &color);
template int
Neon::RmlKhaRender::convertColor(const Rml::ColourbPremultiplied &color);

::haxe::io::Bytes Neon::RmlKhaRender::convertSpanToBytes(
    const Rml::Span<const Rml::byte> &source_data) {
  size_t data_size = source_data.size();
  const Rml::byte *data_ptr = source_data.data();

  haxe::io::Bytes haxeBytes = haxe::io::Bytes_obj::alloc(data_size);
  unsigned char *haxe_data_ptr =
      reinterpret_cast<unsigned char *>(haxeBytes->b->GetBase());
  std::memcpy(haxe_data_ptr, data_ptr, data_size);

  return haxeBytes;
}

/* Rendering Backend
 * covering the interface that directly consume by Application level
 * mostly about memory, lifecyle management
 * --------------------------------------------------------------------- */

bool Backend::Initialize(const char *window_name, int width, int height,
                         bool allow_resize) {
  data = Rml::MakeUnique<BackendData>();
  data->render_interface.SetViewport(width, height);

  return true;
}

void Shutdown() { data.reset(); }

Rml::SystemInterface *Backend::GetSystemInterface() { return nullptr; }

Rml::RenderInterface *Backend::GetRenderInterface() {
  return &data->render_interface;
}

bool Backend::ProcessEvents(Rml::Context *context,
                            KeyDownCallback key_down_callback,
                            bool power_save) {
  return true;
}

void Backend::RequestExit() { data->running = false; }

void Backend::BeginFrame() {
  data->fb->graphics2->begin(true, 0x00000000);
  data->render_interface.BeginFrame();
}

void Backend::SetFramebuffer(::kha::Framebuffer fb) { data->fb = fb; }
void Backend::PresentFrame() {
  data->render_interface.EndFrame();
  data->fb->graphics2->end();
}
