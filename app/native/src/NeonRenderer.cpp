#include "NeonRenderer.h"

namespace neon::platform::catalyst {
// class NeonText : public neon::core::Element {
// public:
//   NeonText() { std::cout << "creating native text!" << std::endl; }
//
//   void setProp(std::string key, std::string value) {}
//
// private:
//   // instance:
// };

neon::Element makeElement(std::string tag) {
	if (tag == "Text") {
		return makeNeonText();
	}
	
	return makeNeonView();
}

neon::Element getRootElement() { return neon::getRootElement(); }

int insert(neon::Element node, neon::Element container,
           std::optional<int> position) {
  container.addChild(node);
  return 0;
}

void setProp(std::string prop, std::any value, neon::Element element) {
	if (value.type() == typeid(std::string)) {
		element.setProp(prop, Atomic::String(std::any_cast<std::string>(value)));
	} else if (value.type() == typeid(float)) {
		element.setProp(prop, Atomic::Float(std::any_cast<float>(value)));
	} else if (value.type() == typeid(int)) {
		element.setProp(prop, Atomic::Float(std::any_cast<int>(value)));
	}
}

void setStyle(std::string attribute, std::any value, neon::Element element) {
	if (value.type() == typeid(std::string)) {
		element.setStyle(attribute, Atomic::String(std::any_cast<std::string>(value)));
	} else if (value.type() == typeid(float)) {
		element.setStyle(attribute, Atomic::Float(std::any_cast<float>(value)));
	} else if (value.type() == typeid(int)) {
		element.setStyle(attribute, Atomic::Float(std::any_cast<int>(value)));
	}
}
} // namespace neon::platform::catalyst
