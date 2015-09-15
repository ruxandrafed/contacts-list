require 'csv'
require 'pry-nav'
require 'pg'

class Contact

  attr_accessor :firstname, :lastname, :email, :id

  def initialize(firstname, lastname, email, id=nil)
    @firstname = firstname
    @lastname = lastname
    @email = email
    @id = id
  end

  def to_s
    "Name: #{@name}, Email: #{email}"
  end

  # Updates or saves a contact to the database, returns the id
  def save
    if @id
      Contact.connection.exec_params("UPDATE contacts SET firstname=$1, lastname=$2, email=$3 WHERE id=$4 RETURNING id;", [@firstname, @lastname, @email, @id])
    else
      Contact.connection.exec_params("INSERT INTO contacts (firstname, lastname, email) VALUES ($1, $2, $3) RETURNING id;", [@firstname, @lastname, @email])
    end
  end

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
    def create(firstname, lastname, email)
      contact = Contact.new(firstname, lastname, email)
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

    def delete(id)
      if find(id)
        find(id).destroy
        puts "Contact with id #{id} was deleted!"
      else
          puts "No contact with this ID!"
          nil
      end
    end

    # Takes a SQL query and params and returns an array of matching Contact instances
    def run_query(query, params=nil)
      matching_contacts = []
      connection.exec_params(query, params).each do |row|
        contact = Contact.new(row['firstname'], row['lastname'], row['email'], row['id'].to_i)
      matching_contacts << contact
      end
      return matching_contacts
    end

  end

end
