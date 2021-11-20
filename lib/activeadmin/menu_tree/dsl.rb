# frozen_string_literal: true

module ActiveAdmin::MenuTree
  # ActiveAdmin::MenuTree::DSL class
  module DSL
    def menu_tree(**args)
      options = menu_tree_config.find_menu_option(id: config.resource_name.name) || {}
      options = options.merge(args)
      menu(**options)
    end

    private

    def menu_tree_config
      ActiveAdmin::MenuTree.config
    end
  end
end
