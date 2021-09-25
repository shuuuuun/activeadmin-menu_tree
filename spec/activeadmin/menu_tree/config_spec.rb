# frozen_string_literal: true

RSpec.describe ActiveAdmin::MenuTree::Config do
  it { should respond_to :menu_tree }
  it { should respond_to :menu_tree= }
  it { should respond_to :menu_options }

  describe "menu_tree=" do
    subject { config.menu_tree = new_value }

    let(:config) { described_class.new }
    let(:new_value) { [] }

    it { expect(config.menu_tree).to eq [] }
    it { expect(config.menu_options).to be_nil }

    context do
      before do
        subject
      end

      it { expect(config.menu_tree).to eq new_value }
      it { expect(config.menu_options).not_to be_nil }
      it { expect(config.menu_options.size).to eq new_value.size }
    end

    context "with invalid value" do
      let(:new_value) { "invalid value" }

      it { expect{ subject }.to raise_error ActiveAdmin::MenuTree::Error }
    end
  end

  describe "find_menu_option" do
    subject { config.find_menu_option(name: name) }

    let(:config) { described_class.new }
    let(:name) { "" }

    before do
      config.menu_tree = [{
        name: "Dashboard"
      }, {
        label: "User",
        children: [{
          name: "User",
          label: "It's Users",
        }]
      }, {
        label: "Other",
        children: [{
          name: "Foo",
          label: "It's Foo"
        }, {
          name: "Bar",
          label: "It's Bar"
        }]
      }]
    end

    it { is_expected.to eq nil }

    context do
      let(:name) { "User" }

      it { is_expected.to include(name: "User", label: "It's Users") }
    end

    context do
      let(:name) { "Foo" }

      it { is_expected.to include(name: "Foo", label: "It's Foo") }
    end

    context do
      let(:name) { "Bar" }

      it { is_expected.to include(name: "Bar", label: "It's Bar") }
    end
  end
end
