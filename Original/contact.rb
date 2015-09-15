require 'csv'

class Contact

  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def to_s
    "Name: #{@name}, Email: #{email}"
  end

  class << self

    # Initializes a contact and adds it to the list of contacts
    def create(name, email, phone_numbers)
      @name = name
      @email = email
      @phone_numbers = phone_numbers.to_a
      ContactDatabase.write([@name, @email, @phone_numbers])
    end

    # Finds and returns contacts that contain the term in the first name, last name or email
    def find(term)
      matches = ContactDatabase.read.select {|entry| entry.to_s.include? (term)}
    end

    # Return the list of contacts, as is
    def all
      ContactDatabase.read
    end

    # Shows a contact based on ID
    def show(id)
      matches = ContactDatabase.read.select {|entry| entry[0] == id.to_s}
    end

    # Checks if an entry with the same email address already exits in the database
    def contact_exists?(email)
      same_email_matches = ContactDatabase.read.select {|entry| entry[2].include?(email)}
      same_email_matches.empty? ? false : true
    end

  end

end
