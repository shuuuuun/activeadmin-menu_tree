# frozen_string_literal: true

RSpec.describe ActiveAdmin::MenuTree::Config do
  let(:sample_menu_tree) do
    [{
      name: "Dashboard"
    }, {
      label: "User",
      children: [{
        name: "User",
        label: "It's User",
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

  it { should respond_to :menu_tree }
  it { should respond_to :menu_tree= }
  it { should respond_to :menu_options }

  describe "menu_tree=" do
    subject { config.menu_tree = new_value }

    let(:config) { described_class.new }
    let(:new_value) { [] }

    it { expect(config.menu_tree).to eq [] }
    it { expect(config.menu_options).to eq [] }

    context do
      let(:new_value) { sample_menu_tree }
      let(:flattened_size) { sample_menu_tree.map{ |item| [item] + (item[:children] || []) }.flatten.compact.size }

      before do
        subject
      end

      it { expect(config.menu_tree).to eq new_value }
      it { expect(config.menu_options).not_to be_empty }
      it { expect(config.menu_options.size).to eq flattened_size }
    end

    context "with invalid value" do
      let(:new_value) { "invalid value" }

      it { expect{ subject }.to raise_error ActiveAdmin::MenuTree::Error }
    end
  end

  describe "menu_options" do
    subject { config.menu_options }

    let(:config) { described_class.new }

    before do
      config.menu_tree = sample_menu_tree
    end

    it { is_expected.not_to be_nil }
    it { expect(subject).to all(include(:label, :priority)) }
    # it { expect(subject).not_to all(include(:children)) }
    it { expect(subject).to all(not_include(:children)) }

    describe "include parent in child items" do
      it { expect(subject.find{ |item| item[:name] == "Dashboard" }).not_to include(:parent) }
      it { expect(subject.find{ |item| item[:name] == "User" }[:parent]).to eq("User") }
      it { expect(subject.find{ |item| item[:name] == "Foo" }[:parent]).to eq("Other") }
      it { expect(subject.find{ |item| item[:name] == "Bar" }[:parent]).to eq("Other") }
    end

    describe "set name to label when no label" do
      let(:labelless_items) { subject.select{ |item| item[:label].blank? && item[:name].present? } }

      it { expect(labelless_items).to all(satisfy{ |item| item[:label] == item[:name].pluralize.titleize }) }
    end
  end

  describe "find_menu_option" do
    subject { config.find_menu_option(name: name) }

    let(:config) { described_class.new }
    let(:name) { "" }

    before do
      config.menu_tree = sample_menu_tree
    end

    it { is_expected.to eq nil }

    context do
      let(:name) { "User" }

      it { is_expected.to include(name: "User", label: "It's User") }
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
