# frozen_string_literal: true

module ActiveAdmin::MenuTree
  class Config
    attr_reader :menu_tree

    def initialize
      @menu_tree = []
    end

    def menu_tree=(new_value)
      raise ActiveAdmin::MenuTree::Error, "Invalid config" unless new_value.is_a? Array

      @menu_tree = new_value.map(&:deep_symbolize_keys)
    end

    def find_menu_option(name:)
      menu_tree.each.with_index(1) do |item, index|
        item[:priority] = index * 10
        return item if item[:name] == name
        next if item[:children].blank?

        item[:children].each.with_index(1) do |child, child_index|
          child[:priority] = child_index
          child[:parent] = item[:label]
          return child if child[:name] == name
        end
      end
      nil
    end
  end
end
