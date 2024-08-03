var project = new Project('neon');

project.addFile('ios/**');
project.addIncludeDir('ios/');

project.addIncludeDir('/Users/le/Projects/RmlUi/Include');
project.addLib('/Users/le/Projects/RmlUi/build/Source/Core/librmlui.dylib');

project.addDefine('KHA_OPENGL');

resolve(project);
