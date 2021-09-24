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
        optioins = item.except(:children)
        optioins[:priority] = index * 10
        optioins[:label] ||= item[:name]&.pluralize&.titleize || ""

        children =
          item[:children]&.map&.with_index(1) do |child, child_index|
            child_options = child.except(:children)
            child_options[:priority] = child_index
            child_options[:label] ||= child[:name]&.pluralize&.titleize || ""
            child_options[:parent] = item[:label]
            child_options
          end || []

        [optioins] + children
      end.flatten.compact
    end
  end
end
