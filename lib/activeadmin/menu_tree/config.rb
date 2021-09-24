# frozen_string_literal: true

module ActiveAdmin::MenuTree
  class Config
    attr_reader :menu_tree, :flattened_menu_options

    def initialize
      @menu_tree = []
    end

    def menu_tree=(new_value)
      raise ActiveAdmin::MenuTree::Error, "Invalid config" unless new_value.is_a? Array

      @menu_tree = new_value.map(&:deep_symbolize_keys)
      @flattened_menu_options = flatten_menu_tree
    end

    def find_menu_option(name:)
      flattened_menu_options.find { |item| item[:name] == name }
    end

    private

    def flatten_menu_tree
      menu_tree.map.with_index(1) do |item, index|
        item[:priority] = index * 10
        item[:label] ||= item[:name]&.pluralize&.titleize || ""

        children =
          if item[:children].blank?
            []
          else
            item[:children].map.with_index(1) do |child, child_index|
              child[:priority] = child_index
              child[:label] ||= child[:name]&.pluralize&.titleize || ""
              child[:parent] = item[:label]
              child.except(:children)
            end
          end
        item = item.except(:children)

        [item] + children
      end.flatten.compact
    end
  end
end
