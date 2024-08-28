#pragma once

#include "iostream"
#include "stdio.h"
#include <swift/bridging>

namespace neon::core {
class Element {
public:
  virtual void setProp(std::string key, std::string value);
}; //SWIFT_CONFORMS_TO_PROTOCOL(neon.Element);

//neon::core::Element makeElement(std::string tag);
} // namespace neon::core
