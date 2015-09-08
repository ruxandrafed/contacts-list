#!/usr/bin/ruby
require 'io/console'
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
    when 'help'
      print_help
    when 'new'
      contact_info = get_contact_info
      Contact.create(contact_info[1], contact_info[2], contact_info[3]) if contact_info != nil
    when 'list'
      all_contacts = Contact.all
      list_contacts(all_contacts)
    when 'show'
      matches = Contact.show(@command_param)
      if matches.empty?
        puts 'Contact not found!'
      else
          puts "Name: #{matches[0][1]}\nEmail: #{matches[0][2]}\nPhone numbers: #{matches[0][3].gsub(/[\[\]""]/, "")}"
      end
    when 'find'
      matches = Contact.find(@command_param)
      matches.each {|match| puts "Name: #{match[1]}\nEmail: #{match[2]}\nPhone numbers: #{match[3].gsub(/[\[\]""]/, "")}"}
    end
  end

  private

  # Prints help menu with command options
  def print_help
    puts 'Here is a list of available commands:'
    puts '- new  - Create a new contact'
    puts '- list - List all contacts'
    puts '- show - Show a contact'
    puts '- find - Find a contact'
  end

  # Gets the name and email for a new contact, returns array with id, name, email
  def get_contact_info
    puts 'Enter email address:'
    email = $stdin.readline().chomp
    if Contact.contact_exists?(email)
      puts 'You\'ve already added this contact!'
      return nil
    else
        puts 'Enter contact name:'
        name = $stdin.readline().chomp
        puts 'Enter phone numbers: (e.g. mobile 604-678-3456, home 345-234-3456'
        phone_numbers = $stdin.readline().chomp.split(", ")
        id = ContactDatabase.read.length + 1
        return [id, name, email, phone_numbers]
    end
  end

  def list_contacts(arr)
    puts 'Showing list of contacts (to see more than five, press space):'
    index = 0
    while index < arr.size
      arr[index,5].each{|arr| puts "#{arr[0]}: #{arr[1]} (#{arr[2]}; #{arr[3].gsub(/[\[\]""]/, "")})"}
      keep_showing = $stdin.getch
      break if keep_showing != " "
      index += 5
    end
  end

end

Application.new.run_command

