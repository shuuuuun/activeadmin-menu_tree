# frozen_string_literal: true

RSpec.describe ActiveAdmin::MenuTree::Config do
  let(:sample_menu_tree) do
    [
      { id: "Dashboard" },
      {
        label: "User",
        children: [
          { id: "User", label: "It's User" }
        ]
      },
      {
        label: "Other",
        children: [
          { id: "Foo", label: "It's Foo" },
          { id: "Bar", label: "It's Bar" }
        ]
      },
      {
        label: "Lorem",
        children: [
          {
            label: "ipsum",
            children: [
              {
                label: "dolor",
                children: [
                  {
                    label: "sit",
                    children: [
                      { label: "amet", url: "https://example.com/", html_options: { target: "blank" } }
                    ]
                  }
                ],
              }
            ],
          }
        ]
      }
    ]
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
      let(:flattened_size) { 11 }

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
    it { expect(subject).to all(include(:priority)) }
    it { expect(subject).to all(not_include(:children)) }

    describe "include parent in child items" do
      it { expect(subject.find{ |item| item[:id] == "Dashboard" }).not_to include(:parent) }
      it { expect(subject.find{ |item| item[:id] == "User" }[:parent]).to eq("User") }
      it { expect(subject.find{ |item| item[:id] == "Foo" }[:parent]).to eq("Other") }
      it { expect(subject.find{ |item| item[:id] == "Bar" }[:parent]).to eq("Other") }
      it { expect(subject.find{ |item| item[:label] == "Lorem" }[:parent]).to be_nil }
      it { expect(subject.find{ |item| item[:label] == "ipsum" }[:parent]).to eq("Lorem") }
      it { expect(subject.find{ |item| item[:label] == "dolor" }[:parent]).to eq(%w[Lorem ipsum]) }
      it { expect(subject.find{ |item| item[:label] == "sit" }[:parent]).to eq(%w[Lorem ipsum dolor]) }
      it { expect(subject.find{ |item| item[:label] == "amet" }[:parent]).to eq(%w[Lorem ipsum dolor sit]) }
    end
  end

  describe "find_menu_option" do
    subject { config.find_menu_option(id: id) }

    let(:config) { described_class.new }
    let(:id) { "" }

    before do
      config.menu_tree = sample_menu_tree
    end

    it { is_expected.to eq nil }

    context do
      let(:id) { "User" }

      it { is_expected.to include(id: "User", label: "It's User") }
    end

    context do
      let(:id) { "Foo" }

      it { is_expected.to include(id: "Foo", label: "It's Foo") }
    end

    context do
      let(:id) { "Bar" }

      it { is_expected.to include(id: "Bar", label: "It's Bar") }
    end
  end
end
