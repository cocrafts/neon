let project = new Project('neonDemo');

project.addDefine('KORE_CPP17'); // Optional: You can define this for conditional compilation
project.addCppFlag('-std=c++17'); // For C++17
project.addCppFlag('-std=gnu++17'); // Use gnu++17 if there are any specific GNU extensions needed

project.addAssets('Assets/**');
project.addAssets('Assets/fonts/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

project.addLibrary('neon');

resolve(project);
