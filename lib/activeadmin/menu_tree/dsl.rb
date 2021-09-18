# frozen_string_literal: true

module ActiveAdmin::MenuTree
  module DSL
    def menu_tree(**args)
      options = menu_tree_config.find_menu_option(name: config.resource_name.name)&.merge(args)
      options = options&.except(:children, :name)
      menu(**options)
    end

    private

    def menu_tree_config
      ActiveAdmin::MenuTree.config
    end
  end
end
