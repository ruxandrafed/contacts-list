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
    def create(name, email)
      @name = name
      @email = email
      ContactDatabase.write([@name, @email])
    end

    # Fnds and returns contacts that contain the term in the first name, last name or email
    def find(term)
      all_contacts = ContactDatabase.read
      matches = all_contacts.select {|entry| entry.to_s.include? (term)}
    end

    # Return the list of contacts, as is
    def all
      ContactDatabase.read.each{|arr| arr.join(", ")}
    end

    # Shows a contact based on ID
    def show(id)
      all_contacts = ContactDatabase.read
      matches = all_contacts.select {|entry| entry[0] == id.to_s}
      puts "Name: #{matches[0][1]}, email: #{matches[0][2]}"
    end

    # Checks if an entry with the same email address already exits in the database
    def contact_exists?(email)
      all_contacts = ContactDatabase.read
      same_email_matches = all_contacts.select {|entry| entry[2].include?(email)}
      same_email_matches.empty? ? false : true
    end

  end

end
