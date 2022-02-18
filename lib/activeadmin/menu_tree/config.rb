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

    def find_menu_option(id:)
      menu_options.find { |item| item[:id] == id }
    end

    private

    def flatten_options(items, parent: nil)
      items.map.with_index(1) do |item, index|
        options = format_options(item, index: index, parent: parent)
        next options unless item[:children].is_a? Array

        next_parent = parent ? [parent, item[:label]].flatten.compact : item[:label]
        children = flatten_options(item[:children], parent: next_parent)
        [options] + children
      end.flatten.compact
    end

    def format_options(item, index:, parent: nil)
      # TODO: validate option
      options = item.except(:children)
      if item.key?(:name)
        ActiveAdmin::MenuTree.warn_deprecated("Use `id` key, instead of `name`.")
        options[:id] ||= item[:name]
      end
      options[:priority] = index * 10
      options[:parent] = parent if parent.present?
      options
    end
  end
end
