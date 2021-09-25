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
        options = format_options(item, index: index, name: item[:name])

        next options unless item[:children].is_a? Array

        children =
          item[:children].map.with_index(1) do |child, child_index|
            format_options(child, index: child_index, name: child[:name], parent: item[:label])
          end

        [options] + children
      end.flatten.compact
    end

    def format_options(item, index:, name:, parent: nil)
      options = item.except(:children)
      options[:priority] = index * 10
      options[:label] ||= name&.pluralize&.titleize || ""
      options[:parent] = parent if parent.present?
      options
    end
  end
end
