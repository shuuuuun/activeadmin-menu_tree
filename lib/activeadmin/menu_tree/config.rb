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
      @menu_options = flatten_options(@menu_tree)
    end

    def find_menu_option(name:)
      menu_options.find { |item| item[:name] == name }
    end

    private

    def flatten_options(items)
      items.map.with_index(1) do |item, index|
        options = format_options(item, index: index, parent: item[:parent])
        next options unless item[:children].is_a? Array

        parent = item[:parent] ? [item[:parent], item[:label]].flatten.compact : item[:label]
        item[:children].each do |child|
          child[:parent] = parent
        end
        children = flatten_options(item[:children])
        [options] + children
      end.flatten.compact
    end

    def format_options(item, index:, parent: nil)
      # TODO: validate option
      options = item.except(:children)
      options[:priority] = index * 10
      options[:id] ||= item[:name]
      options[:parent] = parent if parent.present?
      options
    end
  end
end
