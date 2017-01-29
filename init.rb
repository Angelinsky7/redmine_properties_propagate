Issue.send(:include, PropertiesPropagate::IssuePatch)
Project.send(:include, PropertiesPropagate::ProjectPatch)

Redmine::Plugin.register :properties_propagate do
  name 'Properties Propagate plugin'
  author 'Steven de Marco'
  description 'Propagate some properties to child task'
  version '0.0.1'
  url 'https://github.com/Angelinsky7/redmine_properties_propagate.git'
  author_url 'https://github.com/Angelinsky7/redmine_properties_propagate.git'

  project_module :properties_propagate do
    permission :edit_properties_propagate, {}
  end

  settings :default => {
    :copy_target_version_subtask => '0',
    :tracker_parent_task_ids => [],
    :set_target_version_subtask => '0',
    :tracker_child_task_ids => [],
  },:partial => 'settings/properties_propagate_settings'

end
