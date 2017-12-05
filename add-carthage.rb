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
    # create file fileRef
    # add to group
    ref = the_frameworks_group.new_reference(path)
    frameworks_build_phases.add_file_reference(ref)
    # create build file
    # add build file to frameworks_build_phases
  end
  # target.frameworks_build_phases.each do |framework_phase|
  #   framework_phase.files.each do |build_file|
  #     file_ref = build_file
  #     path = file_ref.path
  #   end
  # end
end

project.save
