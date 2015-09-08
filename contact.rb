require 'csv'
require 'pry'

class Contact

  attr_accessor :name, :email

  def initialize(name, email)
    # TODO: assign local variables to instance variables
    @name = name
    @email = email
  end

  def to_s
    # TODO: return string representation of Contact
    "Name: #{@name}, Email: #{email}"
  end

  ## Class Methods
  class << self

    # Initializes a contact and adds it to the list of contacts
    def create(name, email, phone_numbers)
      @name = name
      @email = email
      @phone_numbers = phone_numbers.to_a
      ContactDatabase.write([@name, @email, @phone_numbers])
    end

    # Fnds and returns contacts that contain the term in the first name, last name or email
    def find(term)
      all_contacts = ContactDatabase.read
      matches = all_contacts.select {|entry| entry.to_s.include? (term)}
    end

    # Return the list of contacts, as is
    def all
      ContactDatabase.read.each{|arr| puts "#{arr[0]}: #{arr[1]} (#{arr[2]})"}
    end

    # Shows a contact based on ID
    def show(id)
      all_contacts = ContactDatabase.read
      matches = all_contacts.select {|entry| entry[0] == id.to_s}
      matches.empty? ? 'Contact not found!' : "Name: #{matches[0][1]}\nEmail: #{matches[0][2]}\nPhone numbers: #{matches[0][3].gsub(/[\[\]""]/, "")}"
    end

    # Checks if an entry with the same email address already exits in the database
    def contact_exists?(email)
      all_contacts = ContactDatabase.read
      same_email_matches = all_contacts.select {|entry| entry[2].include?(email)}
      same_email_matches.empty? ? false : true
    end

  end

end
