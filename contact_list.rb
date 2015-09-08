require_relative 'contact_database'
require_relative 'contact'

# TODO: Implement command line interaction
# This should be the only file where you use puts and gets

@filename = 'contacts.csv'

class Application

  # Initializes class and gets the command and command param from user input
  def initialize
      @command = ARGV[0]
      @command_param = ARGV[1]
  end

  # Runs application
  def run_command
    case @command
    when "help"
      print_help
    when "new"
      contact_info = get_contact_info
      Contact.create(contact_info[1], contact_info[2]) if contact_info != nil
    when "list"
      Contact.all
    when "show"
      puts Contact.show(@command_param)
    when "find"
      matches = Contact.find(@command_param)
      matches.each {|match| puts "Name: #{match[1]}, email: #{match[2]}"}
    end
  end

  #private

  # Prints help menu with command options
  def print_help
    puts "Here is a list of available commands:"
    puts "\t new  - Create a new contact"
    puts "\t list - List all contacts"
    puts "\t show - Show a contact"
    puts "\t find - Find a contact"
  end

  # Gets the name and email for a new contact, returns array with id, name, email
  def get_contact_info
    puts "Enter email address:"
    email = $stdin.readline().chomp
    if Contact.contact_exists?(email)
      puts "You've already added this contact!"
      return nil
    else
        puts "Enter contact name:"
        name = $stdin.readline().chomp
        id = ContactDatabase.read.length + 1
        return [id, name, email]
    end
  end

end

Application.new.run_command

