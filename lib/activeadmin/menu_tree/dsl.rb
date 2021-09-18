# frozen_string_literal: true

module ActiveAdmin::MenuTree
  module DSL
    def menu_tree(**args)
      options = menu_options(name: config.resource_name.name)&.merge(args)
      pp options
      options = options.except(:children, :name)
      # binding.pry if options.blank?
      # pp config.resource_name
      # pp config.resource_name if options.blank?
      menu(**options)
    end

    private

    def menu_options(name:)
      menu_tree_options.find { |item| item[:name] == name } || {}
    end

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
              child.except(:children)
            end
          end
        item = item.except(:children)

        [item] + children
      end.flatten.compact
    end

    def menu_tree_config
      ActiveAdmin::MenuTree.config.menu_tree
    end
  end
end
