Issue.send(:include, RedminePropertiesPropagate::IssuePatch)
Project.send(:include, RedminePropertiesPropagate::ProjectPatch)

Redmine::Plugin.register :redmine_properties_propagate do
  name 'Properties Propagate plugin'
  author 'Steven de Marco'
  description 'Propagate some properties to child task'
  version '0.0.1'
  url 'https://github.com/Angelinsky7/redmine_properties_propagate.git'
  author_url 'https://github.com/Angelinsky7/redmine_properties_propagate.git'

  project_module :redmine_properties_propagate do
    permission :edit_redmine_properties_propagate, {}
  end

  settings :default => {
    :copy_target_version_subtask => '0',
    :tracker_parent_task_ids => [],
    :set_target_version_subtask => '0',
    :tracker_child_task_ids => [],
  },:partial => 'settings/redmine_properties_propagate_settings'

end
