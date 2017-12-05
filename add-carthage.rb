#!/usr/bin/env ruby

require 'set'
require 'xcodeproj'

#system "swift package generate-xcodeproj"
project_file_name = ARGV[0]
target_name = ARGV[1]
if !project_file_name || project_file_name.length <= 0
  Kernel.abort("缺少参数：工程文件名")
end
carthage_package_dir = ARGV[2]
if !carthage_package_dir || carthage_package_dir.length <= 0
  Kernel.abort("缺少参数：Carthage根目录")
end


carthage_rameworks_path_ios = "#{carthage_package_dir}/Build/iOS"
carthage_rameworks_path_ios_full = File.expand_path(carthage_rameworks_path_ios)
current_root_path_full = File.expand_path('.')
current_root_path_relative_to_root = carthage_rameworks_path_ios_full.slice(current_root_path_full.length + 1, carthage_rameworks_path_ios_full.length - current_root_path_full.length)

carthage_framework_files_ios = Dir.entries(carthage_rameworks_path_ios)
.select {|f| f.end_with?(".framework")}
.map {|name| File.expand_path(name, carthage_rameworks_path_ios)}
.map do |abspath|
  prefix_len = File.expand_path('.').length + 1
  abspath.slice(prefix_len, abspath.length - prefix_len)
end


project_file_path = File.expand_path(project_file_name)
project = Xcodeproj::Project.open(project_file_path)

def getGroupWithName(project, name)
  idx = project.groups.find_index {|g| g.display_name && g.display_name.eql?(name)}
  if idx == nil
    return nil
  end
  return project.groups[idx]
end


the_frameworks_group = getGroupWithName(project, "Frameworks")
if !the_frameworks_group
  the_frameworks_group = project.new_group("Frameworks")
end

project.targets.each do |target|
  # module_map_file = "Dependencies.xcodeproj/GeneratedModuleMap/#{target.name}/module.modulemap"
  if !target.display_name.eql?(target_name)
    next
  end

  frameworks_build_phases = target.frameworks_build_phases
  build_files_obj = frameworks_build_phases.files
  build_file_list = build_files_obj.objects
  build_filename_set = Set.new build_file_list.map{|ref| ref.display_name}
  carthage_framework_files_ios.each do |path|
    if build_filename_set.include?(path)
      next
    end
    ref = the_frameworks_group.new_reference(path)
    frameworks_build_phases.add_file_reference(ref)
  end

  run_script_phases = target.shell_script_build_phases
  script_phases_set = Set.new run_script_phases.map {|ph| ph.name}

  script_phase_name = "Auto add frameworks for Carthage"
  if !script_phases_set.include?(script_phase_name)
    phase = target.new_shell_script_build_phase(script_phase_name)
    phase.input_paths = carthage_framework_files_ios.map {|path| "$(SRCROOT)/#{path}"}
    phase.output_paths = carthage_framework_files_ios.map do |path|
      "$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/#{File.basename(path)}"
    end
    phase.shell_script = "/usr/local/bin/carthage copy-frameworks"
  end

  script_phase_name = "Check deps update for Carthage"
  if !script_phases_set.include?(script_phase_name)
    phase = target.new_shell_script_build_phase(script_phase_name)
    phase.shell_script = "/usr/local/bin/carthage outdated --xcode-warnings"
  end

  target.build_configurations.objects.each do |conf|
    settings = conf.build_settings
    paths = settings["FRAMEWORK_SEARCH_PATHS"]
    if !paths
      paths = ["$(inherited)"]
      settings["FRAMEWORK_SEARCH_PATHS"] = paths
    end
    paths.push("$(SRCROOT)/#{current_root_path_relative_to_root}")
  end

end

project.save
