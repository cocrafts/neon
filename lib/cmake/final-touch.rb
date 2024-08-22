require 'xcodeproj'

project = Xcodeproj::Project.open('./build/neon.xcodeproj')

project.targets.each do |target|
  if target.name == "neon"
    target.build_configurations.each do |config|
      build_settings = config.build_settings
      build_settings['LIBRARY_SEARCH_PATHS'] = []
    end
  end
end

project.save
