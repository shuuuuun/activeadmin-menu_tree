# frozen_string_literal: true

require_relative "lib/activeadmin/menu_tree/version"

Gem::Specification.new do |spec|
  spec.name          = "activeadmin-menu_tree"
  spec.version       = ActiveAdmin::MenuTree::VERSION
  spec.authors       = ["shuuuuuny"]
  spec.email         = []

  spec.summary       = "Allows ActiveAdmin menus to be managed in tree format."
  spec.description   = "This is a wrapper library for managing ActiveAdmin's menu structure in a simple yaml format, and automatically setting the priority and parent."
  spec.homepage      = "https://github.com/shuuuuun/activeadmin-menu_tree"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shuuuuun/activeadmin-menu_tree"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activeadmin", "~> 2.8"
  spec.add_dependency "activesupport"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
