require_dependency "project"

module RedminePropertiesPropagate
  module ProjectPatch
    def self.included(base)
      base.class_eval do

        def propertiespropagate?
          is_propertiespropagate = module_enabled?(:redmine_properties_propagate)
          is_propertiespropagate = parent.propertiespropagate? unless is_propertiespropagate or parent.nil?
          return is_propertiespropagate
        end
      end
    end
  end
end