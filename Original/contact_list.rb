#!/usr/bin/ruby
require 'io/console'
require_relative 'contact_database'
require_relative 'contact'

@filename = 'contacts.csv'

class Application

  # Initializes class and gets the command and command param from user input
  def initialize
      @command = ARGV[0]
      @command_param = ARGV[1]
  end

  # Runs application
  def run
    case @command
    when 'help'
      print_help
    when 'new'
      contact_info = get_contact_info
      Contact.create(contact_info[1], contact_info[2], contact_info[3]) if contact_info != nil
    when 'list'
      list_contacts(Contact.all)
    when 'show'
      print_matches_for_id(Contact.show(@command_param))
    when 'find'
      print_matches_for_term(Contact.find(@command_param))
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
        puts 'Enter phone numbers: (e.g. mobile 604-678-3456, home 345-234-3456)'
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

  def print_matches_for_id(arr)
    if arr.empty?
      puts 'Contact not found!'
    else
      puts "Name:\t#{arr[0][1]}\nEmail:\t#{arr[0][2]}\nPhone:\t#{arr[0][3].gsub(/[\[\]""]/, "")}"
    end
  end

  def print_matches_for_term(arr)
    if arr.empty?
      puts 'Contact not found!'
    else
      arr.each {|match| puts "Name:\t#{match[1]}\nEmail:\t#{match[2]}\nPhone:\t#{match[3].gsub(/[\[\]""]/, "")}"}
    end
  end

end

Application.new.run
