#pragma once

#include "neon-Swift.h"
#include "NeonCore.h"
#include "iostream"
#include "stdio.h"
#include <optional>
#include <any>
#include <typeinfo>

namespace neon::platform::catalyst {
neon::Element getRootElement();
neon::Element makeElement(std::string tag);
int insert(neon::Element node, neon::Element container, std::optional<int> position);
void setProp(std::string prop, std::any value, neon::Element element);
void setStyle(std::string attribute, std::any value, neon::Element element);
} // namespace neon::platform::catalyst
