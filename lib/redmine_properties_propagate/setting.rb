module RedminePropertiesPropagate
  class Setting

    %w(copy_target_version_subtask
       set_target_version_subtask).each do |setting|
      src = <<-END_SRC
      def self.#{setting}
        setting_or_default_boolean(:#{setting})
      end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end

    %w(tracker_parent_task_ids
       tracker_child_task_ids).each do |setting|
      src = <<-END_SRC
      def self.#{setting}
        collect_ids(:#{setting})
      end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end

    module TrackerFields
      FIELDS = 'fields'
    end

    def self.tracker_fields(tracker, type = TrackerFields::FIELDS)
      collect("tracker_#{tracker}_#{type}")
    end

    def self.tracker_field?(tracker, field, type = TrackerFields::FIELDS)
      tracker_fields(tracker, type).include?(field.to_s)
    end

private

    def self.setting_or_default(setting)
      ::Setting.plugin_redmine_properties_propagate[setting] || 
      Redmine::Plugin::registered_plugins[:redmine_properties_propagate].settings[:default][setting]
    end

    def self.setting_or_default_boolean(setting)
      setting_or_default(setting) == '1'
    end

    def self.collect_ids(setting)
      (::Setting.plugin_redmine_properties_propagate[setting] || []).collect{|value| value.to_i}
    end

  end
end