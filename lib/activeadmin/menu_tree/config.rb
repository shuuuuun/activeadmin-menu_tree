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
        optioins = format_options(item, index: index, name: item[:name])

        children =
          item[:children]&.map&.with_index(1) do |child, child_index|
            format_options(child, index: child_index, name: child[:name], parent: item[:label])
          end || []

        [optioins] + children
      end.flatten.compact
    end

    def format_options(item, index:, name:, parent: nil)
      optioins = item.except(:children)
      optioins[:priority] = index * 10
      optioins[:label] ||= name&.pluralize&.titleize || ""
      optioins[:parent] = parent if parent.present?
      optioins
    end
  end
end
