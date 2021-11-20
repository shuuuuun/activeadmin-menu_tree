# ActiveAdmin::MenuTree

[![Gem Version](https://badge.fury.io/rb/activeadmin-menu_tree.svg)](https://badge.fury.io/rb/activeadmin-menu_tree)
[![Ruby](https://github.com/shuuuuun/activeadmin-menu_tree/actions/workflows/main.yml/badge.svg)](https://github.com/shuuuuun/activeadmin-menu_tree/actions/workflows/main.yml)

Allows [ActiveAdmin](https://github.com/activeadmin/activeadmin) menus to be managed in tree format.

This is a wrapper library for managing ActiveAdmin's menu structure in a simple yaml format, and automatically setting the priority and parent.

### Motivation

I felt that the normal way of specifying menus in ActiveAdmin is inconvenient when changing it in an application.

Specifically, the two points are as follows:
- Order control by `priority`.
  - To change the order of the menu, we need to change the priority of each resource one by one.
- Managing hierarchical relationships with `parent`.
  - To create a hierarchy, we need to create a parent menu with initializer, and then specify the parent menu from each resource.

The configuration is scattered and burdensome to change.

This gem solves these problems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activeadmin-menu_tree'
```

And then execute:

    $ bundle install

## Usage

### Only 2 steps

In your Rails project with ActiveAdmin.

#### 1. Setup menu_tree

Write the configuration in a yaml file.
```yaml
# config/activeadmin-menu_tree.yml or anywhere you like
activeadmin:
  menu_tree:
    - id: Dashboard
    - label: Admin
      children:
        - id: AdminUser
          label: Admin Users
        - id: Comment
          label: Admin Comments
```

Load it in initializer.
```ruby
# config/initializers/activeadmin-menu_tree.rb
ActiveAdmin::MenuTree.setup do |config|
  config.menu_tree = YAML.load_file(Rails.root.join("config/activeadmin-menu_tree.yml"))["activeadmin"]["menu_tree"]
end
```

#### 2. Call `menu_tree` in ActiveAdmin Resources

You can use `menu_tree` instead of `menu` in ActiveAdmin Resource.
```ruby
# app/admin/admin_users.rb
ActiveAdmin.register AdminUser do
  # No need to specify `priority` or `parent`.
  menu_tree
  # ...
end

# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  # The options available for `menu` can be passed as is.
  menu_tree label: proc { I18n.t("active_admin.dashboard") }
  # ...
end

# Comment resource will be handled specially.
```

### Other ways to load configuration

It is also possible to simply use hash instead of yaml.  
If you want to use dynamic specification using `proc` in menu_tree (instead of in ActiveAdmin Resource), you may want to use this one.

```ruby
ActiveAdmin::MenuTree.setup do |config|
  config.menu_tree = [
    { id: "Dashboard", label: proc { I18n.t("active_admin.dashboard") } },
    {
      label: "Foo",
      if: proc { "Something dynamic" },
      children: [
        { id: "Bar" },
        { id: "Baz" }
      ]
    }
  ]
end
```

If your project uses the [config gem](https://github.com/rubyconfig/config), you can use it by converting it to hash with `to_hash` as follows:
```ruby
ActiveAdmin::MenuTree.setup do |config|
  config.menu_tree = Settings.activeadmin.menu_tree.map(&:to_hash)
end
```
```yaml
# config/settings.yml
activeadmin:
  menu_tree:
    # ...
```

Or you can use other configuration gems like [global gem](https://github.com/railsware/global) by converting them to hash as well.

### Full configuration example

```yaml
activeadmin:
  menu_tree:
    # Specify the resource with `id`.
    - id: Dashboard
    - id: Product
    # Specify a menu label with `label`.
    - label: User Info
      # Specify child elements with `children`.
      children:
        - id: User
        - id: Profile
    - label: Admin
      children:
        - id: AdminUser
          label: Admin Users
        # Comment resource will be handled specially.
        - id: Comment
          label: Admin Comments
    - label: Others
      children:
        - id: Foo
        - id: Bar
    - label: Example Site
      # You can pass the other options available for `menu` DSL, like `url`, `html_options`.
      url: 'https://example.com'
      html_options:
        target: blank
    # Nesting of children is also available.
    - label: Lorem
      children:
        - label: ipsum
          children:
            - label: dolor
              children:
                - label: sit
                  children:
                    - label: amet
                      url: 'https://wikipedia.org/wiki/Lorem_ipsum'
                      html_options:
                        target: blank
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shuuuuun/activeadmin-menu_tree.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
