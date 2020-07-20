# spec/data_row_map.rb
require "user_data_grouper"

describe DataRowMap do
  subject { DataRowMap.new() }

  describe "#add_row_to_item" do

    context "The item does not already exist in the map" do
      let(:test_item) { "some_item" }
      let(:test_row_number) { 1 }
      let(:expected) { [[1]] }

      it "creates an entry in the map and adds the row number" do
        expect(subject.get_values).to eq([])
        subject.add_row_to_item(test_item, test_row_number)
	expect(subject.get_values).to eq(expected)
      end
    end

    context "The item already exists in the map" do
      let(:test_item) { "some_item" }
      let(:test_row_number) { 1 }
      let(:test_row_number_2) { 2 }
      let(:expected) {[[1, 2]]}
 
      before do
        subject.add_row_to_item(test_item, test_row_number)
      end
      
      it "appends the row number to the item's row list" do
	subject.add_row_to_item(test_item, test_row_number_2)
	expect(subject.get_values).to eq(expected)
      end
    end
  end

  describe "#get_values" do
    context "no values exist" do
      let(:expected) { [] }
      it "returns an empty array" do
	expect(subject.get_values).to eq(expected)
      end
    end

    context "values exist for multiple items" do
      let(:test_item) { "some_item" }
      let(:test_item_2) { "some_other_item" }
      let(:test_row_number) { 1 }
      let(:test_row_number_2) { 2 }
      let(:test_row_number_3) { 3 }
      let(:expected) { [[1, 2],[2, 3]] }
      
      before do
	subject.add_row_to_item(test_item, test_row_number)
	subject.add_row_to_item(test_item, test_row_number_2)
        subject.add_row_to_item(test_item_2, test_row_number_2)
	subject.add_row_to_item(test_item_2, test_row_number_3)
      end

      it "returns the values as an array of arrays" do
	expect(subject.get_values).to eq(expected)
      end
    end
  end
end
