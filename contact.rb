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
    def create(name, email)
      # TODO: Will initialize a contact as well as add it to the list of contacts
      @name = name
      @email = email
      ContactDatabase.write([@name, @email])
    end

    def find(term)
      # TODO: Will find and return contacts that contain the term in the first name, last name or email
      all_contacts = ContactDatabase.read
      matches = all_contacts.select {|entry| entry.to_s.include? (term)}
    end

    def all
      # TODO: Return the list of contacts, as is
      ContactDatabase.read.each{|arr| arr.join(", ")}
    end

    def show(id)
      # TODO: Show a contact, based on ID
      all_contacts = ContactDatabase.read
      matches = all_contacts.select {|entry| entry[0] == id.to_s}
      puts "Name: #{matches[0][1]}, email: #{matches[0][2]}"
    end

  end

end
