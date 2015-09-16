#!/usr/bin/ruby
require 'io/console'
require 'colorize'
require_relative 'contact'

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
    when 'find:f'
      print_matches(Contact.find_all_by_firstname(@command_param))
    when 'find:l'
      print_matches(Contact.find_all_by_lastname(@command_param))
    when 'find:e'
      print_match(Contact.find_by_email(@command_param))

    when 'delete'
      if Contact.find(@command_param)
        Contact.delete(@command_param)
        puts "Contact with id #{@command_param} was deleted!".colorize(:green)
      else
        puts "No contact with this ID!".colorize(:red)
      end

    when 'update'
      puts 'Which contact do you want to update? Please give me the id:'.colorize(:blue)
      id_to_update = $stdin.readline().chomp.to_i
      puts "Current information for contact with ID #{id_to_update}:".colorize(:green)
      print_match(Contact.find(id_to_update))
      puts "\nWhat do you want to update? 1 for first name, 2 for last name, 3 for email, 4 for phone numbers:".colorize(:blue)
      update_option = $stdin.readline().chomp
      case update_option
      when '1'
        field_to_update = 'first name'
        print 'Insert new first name: '.colorize(:blue)
        new_value = $stdin.readline().chomp
      when '2'
        field_to_update = 'last name'
        print 'Insert new last name: '.colorize(:blue)
        new_value = $stdin.readline().chomp
      when '3'
        field_to_update = 'email'
        print 'Insert new email: '.colorize(:blue)
        new_value = $stdin.readline().chomp
      when '4'
        field_to_update = 'phone numbers'
        print 'Which phone number to update? (e.g. mobile, home) '.colorize(:blue)
        ph_number_option = $stdin.readline().chomp
        print 'Insert new value: '.colorize(:blue)
        new_value = $stdin.readline().chomp
      end
      update_contact(id_to_update, field_to_update, new_value, ph_number_option)
    end

  end

  private

  # Prints help menu with command options
  def print_help
    puts 'Here is a list of available commands:'
    puts '- new  - Create a new contact'
    puts '- list - List all contacts'
    puts '- show - Show a contact'
    puts '- find:f - Find a contact by first name'
    puts '- find:l - Find a contact by last name'
    puts '- find:e - Find a contact by email'
    puts '- update - Update contact info by id'
    puts '- delete - Delete a contact by id'
  end

  # Gets the name and email for a new contact, returns array with id, name, email, phone numbers
  def get_contact_info
    print "Enter email address:\s".colorize(:blue)
    email = $stdin.readline().chomp
    if Contact.find_by_email(email)
      puts 'You\'ve already added this contact!'
      return nil
    else
        print "Enter first name:\s".colorize(:blue)
        firstname = $stdin.readline().chomp
        print "Enter last name:\s".colorize(:blue)
        lastname = $stdin.readline().chomp

        @list_of_numbers = []
        @keep_looping = true
        read_phone_numbers
        return [firstname, lastname, email, read_phone_numbers]
    end
  end

  # Prompts user for multiple phone numbers; returns array of phone numbers (array of arrays)
  def read_phone_numbers
    while @keep_looping
          puts "Enter phone number: (e.g. mobile 604..; use mobile1, mobile2 if multiple). Type 'done' if finished".colorize(:blue)
          user_input = $stdin.readline.chomp
          if user_input == 'done'
            @keep_looping = false
          else
            @list_of_numbers << user_input.split(" ")
          end
    end
    return @list_of_numbers
  end

  # Takes an array of Contact instances and outputs five at a time, with more shown when user hits space
  def list_contacts(arr)
    puts 'Showing list of contacts (to see more than five, press space):'.colorize(:blue)
    index = 0
    while index < arr.size
      arr[index,5].each{|entry| puts "\nID:\t\t#{entry.id}\nFirst name:\t#{entry.firstname}\nLast name:\t#{entry.lastname}\nEmail:\t\t#{entry.email}\nPhone numbers:\t#{entry.phone_numbers.join(" ")}".colorize(:yellow)}
      keep_showing = $stdin.getch
      break if keep_showing != " "
      index += 5
    end
  end

  # Takes a Contact instance and outputs info about it
  def print_match(entry)
    if entry
      puts "\nID:\t\t#{entry.id}\nFirst name:\t#{entry.firstname}\nLast name:\t#{entry.lastname}\nEmail:\t\t#{entry.email}\nPhone numbers:\t#{entry.phone_numbers.join(" ")}".colorize(:yellow)
    else
      puts "Contact not found!"
    end
  end

  # Takes an array of Contact instances and outputs info about each
  def print_matches(matches)
    if matches != []
      matches.each {|entry| puts "\nID:\t\t#{entry.id}\nFirst name:\t#{entry.firstname}\nLast name:\t#{entry.lastname}\nEmail:\t\t#{entry.email}\nPhone numbers:\t#{entry.phone_numbers.join(" ")}\n".colorize(:yellow)}
    else
      puts "Contact not found!".colorize(:red)
    end
  end

  # Updates a contact in the database
  def update_contact(id, field, new_value, ph_number_option = nil)
    contact = Contact.find(id)
    case field
    when 'first name'
      contact.firstname = new_value
    when 'last name'
      contact.lastname = new_value
    when 'email'
      contact.email = new_value
    when 'phone numbers'
      contact.phone_numbers.each do |phone_no|
        phone_no[1] = new_value if phone_no[0] == ph_number_option
      end
    end
    contact.save
    puts 'Ok, here\'s the updated information:'.colorize(:green)
    print_match(contact)
  end

end

Application.new.run
