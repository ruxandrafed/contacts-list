require 'csv'

class ContactDatabase

  class << self

    # Reads content from @filename CSV and returns array of entries
    def read
      CSV.read('contacts.csv')
    end

    # Takes an array of contacts and writes them to file; automatically assigns id
    def write(arr)
      starting_id = read.length
      CSV.open('contacts.csv', 'a') do |csv|
      csv << arr.unshift(starting_id)
      end
    end
  end
end
