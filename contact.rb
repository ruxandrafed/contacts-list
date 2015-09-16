require 'csv'
require 'pry-nav'
require 'pg'

class Contact

  attr_accessor :firstname, :lastname, :email, :id, :phone_numbers

  def initialize(firstname, lastname, email, phone_numbers = [], id = nil)
    @firstname = firstname
    @lastname = lastname
    @email = email
    @phone_numbers = phone_numbers
    @id = id
  end

  # Updates or saves a contact to the database, returns the id
  def save
    if @id
      Contact.run_query("UPDATE contacts SET firstname=$1, lastname=$2, email=$3 WHERE id=$4 RETURNING id;", [@firstname, @lastname, @email, @id])
    else
      id = Contact.connection.exec_params("INSERT INTO contacts (firstname, lastname, email) VALUES ($1, $2, $3) RETURNING id;", [@firstname, @lastname, @email])[0]['id'].to_i
      @phone_numbers.each do |arr|
        Contact.connection.exec_params("INSERT INTO phone_numbers (number, type, owner_id) VALUES ($1, $2, $3) RETURNING id;", [arr[1], arr[0], id])
      end
      return id
    end
  end

  # Deletes the instance from the database
  def destroy
    Contact.connection.exec_params("DELETE FROM contacts WHERE id = $1;", [@id])
  end

  class << self

    # Establishes connection and returns connection object
    def connection
      PG.connect(
        host: 'localhost',
        dbname: 'contactlist',
        user: 'development',
        password: 'development'
        )
    end

    # Initializes a contact and adds it to the list of contacts
    def create(firstname, lastname, email, phone_numbers)
      contact = Contact.new(firstname, lastname, email, phone_numbers)
      contact.id = contact.save
    end

    # Find a contact based on last name; returns an array of hashes
    def find_all_by_lastname(term)
      run_query("SELECT * FROM contacts WHERE lastname = $1;", [term])
    end

    # Find a contact based on first name; returns an array of hashes
    def find_all_by_firstname(term)
      run_query("SELECT * FROM contacts WHERE firstname = $1;", [term])
    end

    # Find a contact based on email; returns a hash
    def find_by_email(term)
      run_query("SELECT * FROM contacts WHERE email = $1;", [term])[0]
    end

    # Find a contact based on ID; returns a Contact instance or nil if no contact found
    def find(id)
      run_query("SELECT * FROM contacts WHERE id = $1;", [id])[0]
    end

    # Return the list of contacts as an array of Contact instances
    def all
      run_query("SELECT * FROM contacts;")
    end

    # Calls the destroy method on the instance that has that id; returns a PG::Result
    def delete(id)
      find(id).destroy
    end

    # Takes a SQL query and params and returns an array of matching Contact instances
    def run_query(query, params=nil)
      matching_contacts = []
      connection.exec_params(query, params).each do |row|
        contact = Contact.new(row['firstname'], row['lastname'], row['email'], get_phone_numbers(row['id']), row['id'].to_i)
      matching_contacts << contact
      end
      return matching_contacts
    end

    # Takes an ID and returns phone numbers for that ID (an array of arrays)
    def get_phone_numbers(id)
      all_phone_numbers = []
      connection.exec_params("SELECT * FROM phone_numbers WHERE owner_id = $1", [id]).each do |phone_no|
        all_phone_numbers << [phone_no['type'], phone_no['number']]
      end
      return all_phone_numbers
    end

  end

end
