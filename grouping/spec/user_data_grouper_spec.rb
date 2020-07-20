# spec/user_data_grouper.rb
require "user_data_grouper"

describe UserDataGrouper do

  TEST_OUTPUT_FILE_DIR = "test/output/".freeze
  TEST_OUTPUT_ABSOLUTE_PATH = File.expand_path('../files/' + TEST_OUTPUT_FILE_DIR, File.dirname(__FILE__)).freeze
  TEST_EXPECTED_FILE_DIR = File.expand_path('../files/test/expected/', File.dirname(__FILE__)).freeze

  INPUT_FILE_1_PATH = File.expand_path('../files/test/input/input1.csv', File.dirname(__FILE__)).freeze
  INPUT_FILE_2_PATH = File.expand_path('../files/test/input/input2.csv', File.dirname(__FILE__)).freeze
  INPUT_FILE_3_PATH = File.expand_path('../files/test/input/input3.csv', File.dirname(__FILE__)).freeze

  let(:test_args) { [csv_file_path, matching_type, TEST_OUTPUT_FILE_DIR] }
  let(:csv_file_path) { 'some_path' }
  let(:matching_type) { 'some_type' }

  describe "#group" do
    subject { UserDataGrouper.new(*test_args).group }

    let(:output_file) { File.open(TEST_OUTPUT_ABSOLUTE_PATH + '/' + output_file_name) }
    let(:expected_file) { File.open(TEST_EXPECTED_FILE_DIR + '/' + output_file_name) }

    context "matching on email address" do
      let(:matching_type) { "email" }

      context "the file is input1.csv" do
        let(:csv_file_path) { INPUT_FILE_1_PATH }
	let(:output_file_name) { "input1_matched_on_email.csv" }

        it "executes successfully for input1.csv" do
          subject
	  expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
  
      context "the file is input2.csv" do
        let(:csv_file_path) { INPUT_FILE_2_PATH } 
	let(:output_file_name) { "input2_matched_on_email.csv" }

        it "executes successfully for input2.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
  
      context "the file is input3.csv" do
        let(:csv_file_path) { INPUT_FILE_3_PATH } 
	let(:output_file_name) { "input3_matched_on_email.csv" }

        xit "executes successfully for input3.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
    end
  
    context "matching on phone number" do
      let(:matching_type) { "phone" }

      context "the file is input1.csv" do
        let(:csv_file_path) { INPUT_FILE_1_PATH }
	let(:output_file_name) { "input1_matched_on_phone.csv" }

        it "executes successfully for input1.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
  
      context "the file is input2.csv" do
        let(:csv_file_path) { INPUT_FILE_2_PATH } 
	let(:output_file_name) { "input2_matched_on_phone.csv" }

        it "executes successfully for input2.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
  
      context "the file is input3.csv" do
        let(:csv_file_path) { INPUT_FILE_3_PATH } 
	let(:output_file_name) { "input3_matched_on_phone.csv" }

        xit "executes successfully for input3.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
    end

    context "matching on email address or phone number" do
      let(:matching_type) { "email_or_phone" }

      context "the file is input1.csv" do
        let(:csv_file_path) { INPUT_FILE_1_PATH }
	let(:output_file_name) { "input1_matched_on_email_or_phone.csv" }

        it "executes successfully for input1.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
  
      context "the file is input2.csv" do
        let(:csv_file_path) { INPUT_FILE_2_PATH } 
	let(:output_file_name) { "input2_matched_on_email_or_phone.csv" }

        it "executes successfully for input2.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
  
      context "the file is input3.csv" do
        let(:csv_file_path) { INPUT_FILE_3_PATH } 
	let(:output_file_name) { "input3_matched_on_email_or_phone.csv" }

        xit "executes successfully for input3.csv" do
          subject
          expect(FileUtils.identical?(expected_file, output_file)).to be(true) 
        end
      end
    end

    describe "#format_datum_by_type" do
      subject { UserDataGrouper.new(*test_args).format_datum_by_type(test_datum, test_type) }

      context "the type is email" do
	let(:test_type) { "email" }
	
	context "and the email address provided includes capitals" do
	  let(:test_datum) { "BoB@dole.com" } 
	  let(:expected) { "bob@dole.com" }
	  
	  it "downcases all characters" do
            expect(subject).to eq(expected)
	  end
	end

	context "and the email address provided has no capitals" do
	  let(:test_datum) { "bob@dole.com" } 
	  let(:expected) { "bob@dole.com" }
	  
	  it "does nothing" do
            expect(subject).to eq(expected)
	  end
	end

	context "a nil email address is provided" do
       	  let(:test_datum) { nil } 
	  let(:expected) { nil }
	  
	  it "does nothing" do
            expect(subject).to eq(expected)
	  end
	end

	context "an empty string is provided for email address" do
       	  let(:test_datum) { "" } 
	  let(:expected) { "" }
	  
	  it "does nothing" do
            expect(subject).to eq(expected)
	  end
	end
      end
 
      context "the type is phone" do
	let(:test_type) { "phone" }
	
	context "and the phone number provided has parens whitespace and a hyphen" do
	  let(:test_datum) { "(555) 123-4567" } 
	  let(:expected) { "5551234567" }
	  
	  it "strips the non-numeric characters" do
            expect(subject).to eq(expected)
	  end
	end

	context "and the phone number provided has period delimiters" do
	  let(:test_datum) { "444.123.4567" } 
	  let(:expected) { "4441234567" }
	  
	  it "strips the non-numeric characters" do
            expect(subject).to eq(expected)
	  end
	end

        context "and the phone number is 11 digits with a leading 1" do
	  let(:test_datum) { "1-444-123-4567" } 
	  let(:expected) { "4441234567" }
	  
	  it "strips the non-numeric characters and the leading 1" do
            expect(subject).to eq(expected)
	  end
	end
	
        context "and the phone number is 10 digits with a leading 1" do
	  let(:test_datum) { "1444123456" } 
	  let(:expected) { test_datum }
	  
	  it "does not strip the 1" do
            expect(subject).to eq(expected)
	  end
	end

        context "and the phone number is 12 digits with a leading 1" do
	  let(:test_datum) { "144412345678" } 
	  let(:expected) { test_datum }
	  
	  it "does not strip the 1" do
            expect(subject).to eq(expected)
	  end
	end

	context "a nil phone number is provided" do
       	  let(:test_datum) { nil } 
	  let(:expected) { nil }
	  
	  it "does nothing" do
            expect(subject).to eq(expected)
	  end
	end

	context "an empty string is provided for phone number" do
       	  let(:test_datum) { "" } 
	  let(:expected) { "" }
	  
	  it "does nothing" do
            expect(subject).to eq(expected)
	  end
	end
      end

      context "the type is neither email nor phone" do
       	let(:test_type) { "some_type" } 
	let(:test_datum) { "some_datum" }
        let(:expected) { test_datum }
	  
	it "does nothing" do
          expect(subject).to eq(expected)
	end
      end
    end

    describe "#normalize_graph" do
      subject { UserDataGrouper.new(*test_args).normalize_graph(test_graph) }

      context "the input is a valid array of arrays" do 
        context "and contains no overlapping nodes" do
	  let(:test_graph) { [[0, 1], [2], [3, 4, 5]] }
	  let(:expected) { [[0, 1].to_set, [2].to_set, [3, 4, 5].to_set].to_set } 

	  it "returns the original data as a set of sets" do
	    expect(subject).to eq(expected)
	  end
	end

	context "and contains duplicate arrays" do
	  let(:test_graph) { [[0, 1], [2], [2], [3], [0, 1]] }
	  let(:expected) { [[0, 1].to_set, [2].to_set, [3].to_set].to_set } 
	  it "returns a set of sets with dupes removed" do
	    expect(subject).to eq(expected)
	  end
	end

        context "and contains overlapping nodes" do
	  let(:test_graph) { [[0, 1], [1, 2], [3], [4, 5], [4, 1]] }
	  let(:expected) { [[0, 1, 2, 4, 5].to_set, [3].to_set].to_set } 
	  it "normalizes the set" do
	    expect(subject).to eq(expected)
	  end
	end

        context "but is an empty array of arrays" do
	  let(:test_graph) { [[], []] }
	  let(:expected) { [[].to_set, [].to_set].to_set } 
	  it "returns an empty set of sets" do
	    expect(subject).to eq(expected)
	  end
	end
      end

      context "the input is not a valid array of arrays" do 
        context "but is a single level array" do
	  let(:test_graph) { [1, 2, 3] }
	  let(:expected) { false } 

	  it "returns false" do
	    expect(subject).to eq(expected)
	  end
	end

        context "is nil" do
	  let(:test_graph) { nil }
	  let(:expected) { false } 

	  it "returns false" do
	    expect(subject).to eq(expected)
	  end
	end
      end
    end

    describe "#filename_from_path" do
      subject { UserDataGrouper.new(*test_args).filename_from_path(test_path) }
      context "path is valid" do
	context "and contains multiple directories with a file" do
	  let(:test_path) { "/some_dir/another_dir/some_filename.some_extention" }
	  let(:expected) { "some_filename" }

	  it "returns the expected filename" do
            expect(subject).to eq(expected)       
	  end
	end

        context "and contains only a filename with an extension" do
	  let(:test_path) { "some_filename.some_extention" }
	  let(:expected) { "some_filename" }

	  it "returns the expected filename" do
            expect(subject).to eq(expected)       
	  end
	end
	
	context "and contains a directory with a file but no extension" do
	  let(:test_path) { "some_dir/some_filename" }
	  let(:expected) { "some_filename" }

	  it "returns the expected filename" do
            expect(subject).to eq(expected)       
	  end
	end
      end

      context "path is invalid" do
	context "and is not a string" do
	  let(:test_path) { :some_path }
	  let(:expected) { false }

	  it "returns false" do
            expect(subject).to eq(expected)       
	  end
	end

        context "and is nil" do
	  let(:test_path) { nil }
	  let(:expected) { false }

	  it "returns false" do
            expect(subject).to eq(expected)       
	  end
	end

	context "and is an empty string" do
	  let(:test_path) { "" }
	  let(:expected) { false }

	  it "returns false" do
            expect(subject).to eq(expected)       
	  end
	end
      end
    end

    describe "#headers_to_match_from_matching_type" do
      subject { UserDataGrouper.new(*test_args).headers_to_match_from_matching_type(test_type) }
      let(:test_email_address_headers) { "test_email_address_headers" }
      let(:test_phone_number_headers) { "test_phone_number_headers" }
      before do
	stub_const("UserDataGrouper::KNOWN_EMAIL_ADDRESS_HEADERS", test_email_address_headers)
	stub_const("UserDataGrouper::KNOWN_PHONE_NUMBER_HEADERS", test_phone_number_headers)
      end
      
      context "type is email" do
	let(:test_type) { "email" }
	let(:expected) { test_email_address_headers }
	it "returns the email headers" do
	  expect(subject).to eq(expected)
	end
      end

      context "type is phone" do
	let(:test_type) { "phone" }
	let(:expected) { test_phone_number_headers }
	it "returns the phone number headers" do
	  expect(subject).to eq(expected)
	end
      end

      context "type is email_or_phone" do
	let(:test_type) { "email_or_phone" }
	let(:expected) { test_email_address_headers + test_phone_number_headers }
	it "returns both email and phone headers" do
	  expect(subject).to eq(expected)
	end
      end

      context "type is something else" do
	let(:test_type) { "some_type" }
	let(:expected) { false }
	it "returns false" do
	  expect(subject).to eq(expected)
	end
      end

      context "type is nil" do
	let(:test_type) { nil }
	let(:expected) { false }
	it "returns false" do
	  expect(subject).to eq(expected)
	end
      end

      context "type is an empty string" do
	let(:test_type) { "" }
	let(:expected) { false }
	it "returns false" do
	  expect(subject).to eq(expected)
	end
      end
    end
          	
    describe "#get_matching_data" do
      subject { UserDataGrouper.new(*test_args).get_matching_data(test_row, test_match_cols) }
      let(:test_headers) { ["h1", "h2", "h3", "h4"] }
      let(:test_row) { CSV::Row.new(test_headers, test_row_data) } 
   
      before do	      
        allow_any_instance_of(UserDataGrouper).to receive(:format_datum_by_type) { |_caller, data, _type| data }
      end

      context "a row with data in each of the match columns" do
	let(:test_row_data) { ["d1", "d2", "d3", "d4"] }
	let(:test_match_cols) { [0, 2, 3] }
	let(:expected) { ["d1", "d3", "d4"] }

	it "returns the matching data as an array" do
          expect(subject).to eq(expected)
	end
      end

      context "a row with some empty columns" do
	let(:test_row_data) { ["d1", nil, "d3", ""] }
	let(:test_match_cols) { [0, 1, 2, 3] }
	let(:expected) { ["d1", "d3"] }

	it "returns the matching data as an array ignoring nil and empty string" do
          expect(subject).to eq(expected)
	end
      end

      context "a row with no data in matching columns" do
	let(:test_row_data) { ["d1", nil, "d3", ""] }
	let(:test_match_cols) { [1, 3] }
	let(:expected) { [] }

	it "returns an empty array" do
          expect(subject).to eq(expected)
	end
      end
    end 
  end
end
