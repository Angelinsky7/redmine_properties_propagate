require_dependency 'issue'

module RedminePropertiesPropagate
  module IssuePatch
    def self.included(base)
      base.class_eval do

        attr_accessor :version_was_changed

        before_save :prepare_update_subtasks, :if => lambda { |issue|
          issue.project.propertiespropagate? and 
          RedminePropertiesPropagate::Setting.copy_target_version_subtask and
          issue.fixed_version_id_changed?
        }
        after_save :update_subtasks, :if => lambda { |issue|
          issue.project.propertiespropagate? and 
          RedminePropertiesPropagate::Setting.copy_target_version_subtask and
          issue.version_was_changed?
        }

        before_save :init_subtasks, :if => lambda { |issue|
          issue.project.propertiespropagate? and 
          RedminePropertiesPropagate::Setting.set_target_version_subtask and
          issue.new_record? and !issue.parent_id.nil? and
          issue.fixed_version_id.nil?
        }

        def version_was_changed?
          return self.version_was_changed != nil
        end

      private

        def prepare_update_subtasks
           self.version_was_changed = true
        end

        def update_subtasks
          self.version_was_changed = nil

          if RedminePropertiesPropagate::Setting.tracker_parent_task_ids.include?(self.tracker_id)  
            children.each do |subtask|
                if(RedminePropertiesPropagate::Setting.tracker_child_task_ids.include?(subtask.tracker_id)  )
                  subtask.init_journal(User.current)
                  subtask.fixed_version_id = fixed_version_id;
                  subtask.save!
                end
            end
          end
        end

        def init_subtasks
          if RedminePropertiesPropagate::Setting.tracker_child_task_ids.include?(self.tracker_id)  
            self.fixed_version_id = self.parent.fixed_version_id;
          end
        end
    
      end
    end
  end
end