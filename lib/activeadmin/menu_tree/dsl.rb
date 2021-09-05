# frozen_string_literal: true

module ActiveAdmin::MenuTree
  module DSL
    def menu_tree
      options = menu_tree_options.find { |item| item[:name] == config.resource_name.name } || {}
      # pp options
      # binding.pry if options.blank?
      # pp config.resource_name if options.blank?
      menu **options
    end

    private

    def menu_tree_options
      menu_tree_config.map.with_index(1) do |item, index|
        item[:priority] = index * 10

        children =
          if item[:children].blank?
            []
          else
            item[:children].map.with_index(1) do |child, child_index|
              child[:priority] = child_index
              child[:parent] = item[:label]
              child.delete(:children)
              child
            end
          end
        item.delete(:children)

        [item] + children
      end.flatten.compact
    end

    def menu_tree_config
      ActiveAdmin::MenuTree.config.menu_tree
    end
  end
end
