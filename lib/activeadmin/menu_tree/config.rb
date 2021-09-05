# frozen_string_literal: true

module ActiveAdmin::MenuTree
  class Config
    attr_accessor :menu_tree

    def initialize
      @menu_tree = []
    end
  end
end
