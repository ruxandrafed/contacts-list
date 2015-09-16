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
      Contact.create(contact_info[0], contact_info[1], contact_info[2], contact_info[3]) if contact_info != nil
    when 'list'
      list_contacts(Contact.all)
    when 'show'
      print_match(Contact.find(@command_param))
    when 'findF'
      print_matches(Contact.find_all_by_firstname(@command_param))
    when 'findL'
      print_matches(Contact.find_all_by_lastname(@command_param))
    when 'findE'
      print_match(Contact.find_by_email(@command_param))
    when 'delete'
      if Contact.find(@command_param)
        Contact.delete(@command_param)
        puts "Contact with id #{@command_param} was deleted!"
      else
        puts "No contact with this ID!"
      end
    end
  end

  private

  # Prints help menu with command options
  def print_help
    puts 'Here is a list of available commands:'
    puts '- new  - Create a new contact'
    puts '- list - List all contacts'
    puts '- show - Show a contact'
    puts '- findF - Find a contact by first name'
    puts '- findL - Find a contact by last name'
    puts '- findE - Find a contact by email'
    puts '- delete - Delete a contact by id'
  end

  # Gets the name and email for a new contact, returns array with id, name, email, phone numbers
  def get_contact_info
    puts 'Enter email address:'
    email = $stdin.readline().chomp
    if Contact.find_by_email(email)
      puts 'You\'ve already added this contact!'
      return nil
    else
        puts 'Enter first name:'
        firstname = $stdin.readline().chomp
        puts 'Enter last name:'
        lastname = $stdin.readline().chomp

        list_of_numbers = []
        keep_looping = true
        while keep_looping
          puts 'Enter phone number: (e.g. mobile 6046783456) or DONE if finished'
          user_input = $stdin.readline.chomp
          if user_input == 'DONE'
            keep_looping = false
          else
            list_of_numbers << user_input.split(" ")
          end
        end
        return [firstname, lastname, email, list_of_numbers]
    end
  end

  # Takes an array of Contact instances and outputs five at a time, with more shown when user hits space
  def list_contacts(arr)
    puts 'Showing list of contacts (to see more than five, press space):'
    index = 0
    while index < arr.size
      arr[index,5].each{|entry| puts "ID #{entry.id} | First name: #{entry.firstname} | Last name: #{entry.lastname} | Email: #{entry.email} | Phone numbers: #{entry.phone_numbers.join(" ")}"}
      keep_showing = $stdin.getch
      break if keep_showing != " "
      index += 5
    end
  end

  # Takes a Contact instance and outputs info about it
  def print_match(entry)
    if entry
      puts "\nFirst name:\t#{entry.firstname}\nLast name:\t#{entry.lastname}\nEmail:\t#{entry.email}\nPhone numbers:\t#{entry.phone_numbers.join(" ")}"
    else
      puts "\nContact not found!"
    end
  end

  # Takes an array of Contact instances and outputs info about each
  def print_matches(matches)
    if matches
      matches.each {|entry| puts "\nFirst name:\t#{entry.firstname}\nLast name:\t#{entry.lastname}\nEmail:\t#{entry.email}\nPhone numbers:\t#{entry.phone_numbers.join(" ")}\n"}
    else
      puts "\nContact not found!"
    end
  end

end

Application.new.run
