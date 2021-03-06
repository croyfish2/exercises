# encoding: utf-8
require 'csv'

class UserDataGrouper
  attr_accessor :input_file, :input_headers, :filename, :matching_type, :output_dir, :data_row_map, :match_columns

  ACCEPTED_MATCHING_TYPES = %w"email phone email_or_phone".freeze
  KNOWN_EMAIL_ADDRESS_HEADERS = %w"Email Email1 Email2".freeze
  KNOWN_PHONE_NUMBER_HEADERS = %w"Phone Phone1 Phone2".freeze

  def initialize(input_file, matching_type, output_dir = "output/")
    @input_file = input_file
    @input_headers = []
    @filename = filename_from_path(input_file)
    @matching_type = matching_type
    @match_columns = []
    @output_dir = output_dir
    @data_row_map = DataRowMap.new()
    @write_file = absolute_path_from_relative(output_file)
  end

  def group
    CSV.open(@write_file, "wb") do |csv_output|

      headers_to_match = headers_to_match_from_matching_type(matching_type)
      user_attribute_graph = build_user_attribute_graph(headers_to_match)

      output_headers = ["ID"].concat(@input_headers)
      csv_output << output_headers

      grouped_sets = normalize_graph(user_attribute_graph.get_values)
      new_csv_table = new_csv_with_prepended_ids(grouped_sets, output_headers)

      new_csv_table.each do |row|
        csv_output << row if row
      end

    end
  end

  def format_datum_by_type(datum, type)
    return datum if datum.nil? || datum.empty?
    case type
    when "email"
      return datum&.to_s&.downcase
    when "phone"
      numeric_phone_number = datum&.to_s&.gsub(/\D+/, '')
      numeric_phone_number.slice!(0) if numeric_phone_number.length == 11
      return numeric_phone_number
    else
      datum 
    end
  end

  # Reorganizes the sets provided such that all connected nodes (e.g., people or personal info)
  # belong to the same sets
  # Takes an array of arrays (graph) as input and returns the normalized graph data 
  # This is the application's primary bottleneck. The time complexity is n ^ 2.
  # It would be nice to discover a more efficient algorithm or tool to accomplish this task
  #
  def normalize_graph(l)
    return false if l.nil? || l.empty?
    return false unless l.kind_of?(Array) && l[0].kind_of?(Array)
    output = []

    while l.length > 0
      first, *rest = l
      first = first.to_set

      # We don't have to look for duplicates if there is only one user row for the data item
      if first.length == 1
	output << first
	l = rest
	next
      end

      lf = -1
      while first.length > lf
        lf = first.length
        rest2 = []
        rest.each do |r|
          r_set = r.to_set
          if (first & r_set).length > 0 
    	    first |= r_set
          else
            rest2 << r
          end
        end
      end
      output << first
      l = rest2
    end
    output.to_set
  end

  def filename_from_path(path)
    return false unless path.kind_of?(String)
    return false if path.nil? || path.empty?  
    path.split('/')[-1].split('.')[0]
  end

  def absolute_path_from_relative(relative_path)
    File.expand_path(relative_path, File.dirname(__FILE__))
  end

  def output_file	
    "../files/#{output_dir}#{filename}_matched_on_#{matching_type}.csv"
  end

  def headers_to_match_from_matching_type(type)
    case type 
    when "email"
      return KNOWN_EMAIL_ADDRESS_HEADERS
    when "phone"
      return KNOWN_PHONE_NUMBER_HEADERS
    when "email_or_phone"
      return KNOWN_EMAIL_ADDRESS_HEADERS + KNOWN_PHONE_NUMBER_HEADERS 
    else
      false
    end
  end

  # Takes a CSV::row object and an array of columns to pluck data from
  # and returns an array of the data excluding nil and empty values
  # 
  def pluck_data(row, match_columns)
    plucked_data = []        	
    match_columns.each do |index|
      unformatted_datum = row[index]
      unless unformatted_datum.nil? || unformatted_datum.empty?
        type = (KNOWN_EMAIL_ADDRESS_HEADERS.include? row.headers[index]) ? "email" : "phone"
        formatted_datum_at_index = format_datum_by_type(unformatted_datum, type)
        plucked_data << formatted_datum_at_index 
      end	
    end
    plucked_data
  end

  def new_csv_with_prepended_ids(grouped_sets, output_headers)
    # read in entire input CSV to copy the rows and write to the output file
    csv_input = CSV.read(input_file, headers:true) 
    new_csv_table = Array.new(csv_input.length)
    grouped_sets.each.with_index do |grouped_set, index|	
      grouped_set.each do |row_number| 
        new_row_data = CSV.parse("#{index + 1},#{csv_input[row_number - 1]}")
	  new_row = CSV::Row.new(output_headers, new_row_data[0])
        new_csv_table[row_number - 1] = new_row
      end
    end
    new_csv_table
  end

  def build_user_attribute_graph(headers_to_match)

    data_row_map = DataRowMap.new()

    # slurp in the input CSV to construct the graph of the data we need to normalize
    CSV.foreach(input_file, headers:true).with_index(1) do |row, ln|

      # grab the headers from the first line
      if (ln == 1)
        @input_headers = row.headers
        input_headers.each.with_index do |header, index|
          match_columns << index if headers_to_match.include? header
        end
      end

      plucked_data = pluck_data(row, match_columns)      	

      plucked_data.each do |datum|
        data_row_map.add_row_to_item(datum, ln)
      end
    end

    data_row_map
  end
end

# A small class to define a one to many mapping of personal data (email or phone) to
# User data row numbers stored as an array 
#
class DataRowMap

  def initialize()
    @data_row_map = {}
  end
  
  def add_row_to_item(item, row_number)
    if data_row_map[item]
      data_row_map[item] << row_number
    else
      data_row_map[item] = [row_number]
    end
  end
  
  def get_values
    data_row_map.values
  end

  private

  def data_row_map
    @data_row_map
  end
end
