# frozen_string_literal: true

module ActiveAdmin::MenuTree
  # ActiveAdmin::MenuTree::Config class
  class Config
    attr_reader :menu_tree, :menu_options

    def initialize
      @menu_tree = []
      @menu_options = []
    end

    def menu_tree=(new_value)
      raise ActiveAdmin::MenuTree::Error, "Invalid config" unless new_value.is_a? Array

      @menu_tree = new_value.map(&:deep_symbolize_keys)
      @menu_options = flatten_menu_tree
    end

    def find_menu_option(name:)
      menu_options.find { |item| item[:name] == name }
    end

    private

    def flatten_menu_tree
      menu_tree.map.with_index(1) do |item, index|
        options = format_options(item, index: index)
        next options unless item[:children].is_a? Array

        children =
          item[:children].map.with_index(1) do |child, child_index|
            format_options(child, index: child_index, parent: item[:label])
          end

        [options] + children
      end.flatten.compact
    end

    def format_options(item, index:, parent: nil)
      options = item.except(:children)
      options[:priority] = index * 10
      options[:label] ||= item[:name]&.pluralize&.titleize || ""
      options[:parent] = parent if parent.present?
      options
    end
  end
end
