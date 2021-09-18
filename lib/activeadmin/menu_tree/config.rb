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
  end
end
