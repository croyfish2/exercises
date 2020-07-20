# Grouping Application

Grouping Application is a lightweight Ruby app that can be used to identify possible duplicate rows in csv files representing user data.


## Features

* Group rows by email, phone, or both
* Creates Unique IDs for individual user data rows identified as matching by the provided matching criteria and prepends them to the output csv


## Requirements

* Ruby 2.6.1+


## Usage

* Clone into the exercises/ repo
* `cd` to `/grouping` and `bundle install`
* To run the application against a csv file containing user data, do `ruby grouping.rb <file> <matching_type>`
* Allowed matching types are `email`, `phone`, and `email_or_phone`
* The output csv file will be in the `grouping/files/output/` directory as `<input_filename>_grouped_by_<matching_type>.csv`
* To run the unit tests, do `bundle exec rspec`


## Examples

* `ruby grouping.rb files/input/input1.csv email`
* `ruby grouping.rb files/input/input2.csv email_or_phone`


## Notes

* The currently recognized column headers for email are `Email`, `Email1`, and `Email2`
* The currently recognized column headers for phone are `Phone`, `Phone1`, and `Phone2`
