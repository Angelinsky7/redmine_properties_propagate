require_dependency 'issue'

module PropertiesPropagate
  module IssuePatch
    def self.included(base)
      base.class_eval do

        before_save :update_subtasks, :if => lambda { |issue|
          issue.project.propertiespropagate? and 
          PropertiesPropagate::Setting.copy_target_version_subtask and
          (issue.fixed_version_id_changed? or issue.new_record?) and
          issue.parent_id.nil?
        }
        before_save :init_subtasks, :if => lambda { |issue|
          issue.project.propertiespropagate? and 
          PropertiesPropagate::Setting.set_target_version_subtask and
          issue.new_record? and !issue.parent_id.nil? and
          issue.fixed_version_id.nil?
        }

      private

        def update_subtasks
          if PropertiesPropagate::Setting.tracker_parent_task_ids.include?(self.tracker_id)  
            self.children.each do |subtask|
                if(PropertiesPropagate::Setting.tracker_child_task_ids.include?(subtask.tracker_id)  )
                  subtask.init_journal(User.current)
                  subtask.fixed_version_id = self.fixed_version_id;
                  subtask.save!
                end
            end
          end
        end

        def init_subtasks
          if PropertiesPropagate::Setting.tracker_child_task_ids.include?(self.tracker_id)  
            self.fixed_version_id = self.parent.fixed_version_id;
          end
        end
    
      end
    end
  end
end