# ActiveAdmin::MenuTree

<!-- TODO: badge -->

<!-- 
ActiveAdminのmenuをtree形式で指定できるようにします
Allow ActiveAdmin's menu to be specified in tree format.

ActiveAdminのmenuがtree形式で指定できるようになります
ActiveAdmin's menu can now be specified as a tree.
ActiveAdmin's menu can be specified as a tree.

ActiveAdminのmenuをtree形式で指定できるように拡張します。
ActiveAdmin's menu can be extended to be specified in a tree format.
ActiveAdmin's menu will be extended to be specified in a tree format.

ActiveAdminのmenuをtree形式で管理できるようにします.
Makes it possible to manage ActiveAdmin's menu in a tree format.
Allows ActiveAdmin menus to be managed as a tree format.
 -->
Allows [ActiveAdmin](https://github.com/activeadmin/activeadmin) menus to be managed in tree format.

<!-- ActiveAdminのmenu構造をyamlでシンプルに管理し、priorityとparentを自動で設定するラッパーライブラリです -->
This is a wrapper library for managing ActiveAdmin's menu structure in a simple yaml format, and automatically setting the priority and parent.

### Motivation

<!-- 
ActiveAdminの通常のmenu指定方法は、アプリケーションを運用する上で使いづらいと感じました.
ActiveAdminの通常のmenu指定方法は、アプリケーションを運用していると使いづらいと感じました.
ActiveAdminの通常のmenu指定方法は、運用するアプリケーションでは使いづらいと感じました.
The normal way of specifying the menu in ActiveAdmin is considered to be difficult to use when running an application.
The normal way of specifying the menu in ActiveAdmin is not easy to use for running applications.

ActiveAdmin's normal way of specifying the menu was difficult to use for the application in operation.

The normal way of specifying the menu in ActiveAdmin is difficult to use in the application operation.
I found ActiveAdmin's normal method of specifying the menu to be difficult to use with the application in operation.
I found it difficult to use the normal menu specification method of ActiveAdmin in operating the application.
I found it difficult to use the normal menu specification method of ActiveAdmin when operating an application.
I found it difficult to use the normal menu specification method of ActiveAdmin in the application to be operated.

ActiveAdminの通常のmenu指定方法は、運用中のアプリケーションで変更する際に不便だと感じました.
I found it inconvenient to change the normal menu specification method of ActiveAdmin in the application in operation.
 -->
I felt that the normal way of specifying menus in ActiveAdmin is inconvenient when changing it in an application.

<!-- 
具体的には以下の2点です
・`priority`による順序の制御
・・menuの順番を変えるのに各リソースのpriorityを数値で一つずついじる必要がある
・`parent`による階層関係の管理
・・階層を作るには、initializerで親menuを作成し、さらに各リソースから親menuの指定が必要

設定が分散しており、煩雑です
設定が分散しており、変更が面倒です
 -->
Specifically, the two points are as follows:
- Order control by `priority`.
  - To change the order of the menu, we need to change the priority of each resource one by one.
- Managing hierarchical relationships with `parent`.
  - To create a hierarchy, we need to create a parent menu with initializer, and then specify the parent menu from each resource.

The configuration is scattered and burdensome to change.

This gem solves these problems.

<!-- 
### Features
 -->

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
    - name: Dashboard
    - label: Admin
      children:
        - name: AdminUser
          label: Admin Users
        - name: Comment
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
# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  # The options available for `menu` can be passed as is.
  menu_tree label: proc { I18n.t("active_admin.dashboard") }
  # ...
end

# app/admin/admin_users.rb
ActiveAdmin.register AdminUser do
  # No need to specify `priority` or `parent`.
  menu_tree
  # ...
end

# Comment resource will be handled specially.
```

### Other ways to load configuration

It is also possible to simply use hash instead of yaml.
```ruby
ActiveAdmin::MenuTree.setup do |config|
  config.menu_tree = [{
    name: "Dashboard"
  }, {
    label: "Foo",
    children: [{
      name: "Bar"
    }, {
      name: "Baz"
    }]
  }]
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
    # Specify the resource name with `name`.
    - name: Dashboard
    - name: Product
    # Specify a menu label with `label`.
    - label: User Info
      # Specify child elements with `children`.
      children:
        - name: User
        - name: Profile
    - label: Admin
      children:
        - name: AdminUser
          label: Admin Users
        # Comment resource will be handled specially.
        - name: Comment
          label: Admin Comments
    - label: Others
      children:
        - name: Foo
        - name: Bar
    - label: Example Site
      # You can pass the other options available for `menu` DSL, like `url`, `html_options`.
      url: 'https://example.com'
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
