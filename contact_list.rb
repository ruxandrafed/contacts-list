#!/usr/bin/ruby
require 'io/console'
require 'colorize'
require_relative 'setup'
require_relative 'contact'
require_relative 'phone_number'

class Application

  # Initializes class and gets the command and command param from user input
  def initialize
      @command = ARGV[0]
      @param = ARGV[1]
  end

  # Runs application
  def run
    case @command

    when 'help'
      print_help

    when 'new'
      add_new_contact

    when 'list'
      list_contacts(Contact.all)

    when 'show'
      if Contact.where(id: @param).empty?
        puts "No contact with this ID!".colorize(:red)
      else
        print_contacts(Contact.where(id: @param))
      end

    when 'find:f'
      print_contacts(Contact.where(firstname: @param))
    when 'find:l'
      print_contacts(Contact.where(lastname: @param))
    when 'find:e'
      print_contacts(Contact.where(email: @param))

    when 'delete'
      if Contact.find(@param)
        Contact.find(@param).destroy
        puts "Contact with id #{@param} was deleted!".colorize(:green)
      else
        puts "No contact with this ID!".colorize(:red)
      end

    when 'update'
      puts 'Which contact do you want to update? Please give me the id:'.colorize(:blue)
      id_to_update = get_input.to_i

      puts "Current information for contact with ID #{id_to_update}:".colorize(:green)
      print_contacts(Contact.where(id: id_to_update))

      puts "\nWhat do you want to update? 1 for first name, 2 for last name, 3 for email, 4 for phone numbers:".colorize(:blue)
      update_option = get_input

      case update_option
      when '1'
        field_to_update = 'first name'
        print 'Insert new first name: '.colorize(:blue)
        new_value = get_input
      when '2'
        field_to_update = 'last name'
        print 'Insert new last name: '.colorize(:blue)
        new_value = get_input
      when '3'
        field_to_update = 'email'
        print 'Insert new email: '.colorize(:blue)
        new_value = get_input
      when '4'
        field_to_update = 'phone numbers'
        print 'Which phone number to update? (e.g. mobile, home) '.colorize(:blue)
        phone_type = get_input
        print 'Insert new value: '.colorize(:blue)
        new_value = get_input
      else
        print "No such option!".colorize(:red)
      end

      update_contact(id_to_update, field_to_update, new_value, phone_type)

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
  def add_new_contact
    print "Enter email address:\s".colorize(:blue)
    email = get_input

    if Contact.find_by_email(email)
      puts 'You\'ve already added this contact!'
      return nil
    else
        print "Enter first name:\s".colorize(:blue)
        firstname = get_input
        print "Enter last name:\s".colorize(:blue)
        lastname = get_input
        new_contact = Contact.create(firstname: firstname, lastname: lastname, email: email)
        @all_numbers = []
        @keep_looping = true
        new_contact.phone_numbers = get_phone_numbers
        return [firstname, lastname, email, get_phone_numbers]
    end
  end

  # Prompts user for multiple phone numbers; returns array of phone numbers (array of arrays)
  def get_phone_numbers
    while @keep_looping
          puts "Enter phone number: (e.g. mobile 604..; use mobile1, mobile2 if multiple). Type 'done' if finished".colorize(:blue)
          user_input = $stdin.readline.chomp
          if user_input == 'done'
            @keep_looping = false
          else
            @all_numbers << PhoneNumber.create(phonetype: user_input.split(" ")[0], number: user_input.split(" ")[1])
          end
    end
    return @all_numbers
  end

  # Takes an array of Contact instances and outputs five at a time, with more shown when user hits space
  def list_contacts(arr)
    puts 'Showing list of contacts (to see more than five, press space):'.colorize(:blue)
    index = 0
    while index < arr.size
      arr[index,5].each{|entry| puts entry}
      keep_showing = $stdin.getch
      break if keep_showing != " "
      index += 5
    end
  end

  # Takes an array of Contact instances and outputs info about each
  def print_contacts(matches)
    if matches != []
      matches.each {|entry| puts entry}
    else
      puts "Contact not found!".colorize(:red)
    end
  end

  # Updates a contact in the database
  def update_contact(id, field, new_value, phone_type = nil)
    contact = Contact.find(id)
    case field
    when 'first name'
      contact.firstname = new_value
    when 'last name'
      contact.lastname = new_value
    when 'email'
      contact.email = new_value
    when 'phone numbers'
      contact.phone_numbers.find_by_phonetype(phone_type).update(number: new_value)
    end
    contact.save
    puts 'Ok, here\'s the updated information:'.colorize(:green)
    print_contacts([contact])
  end

  # Reads input from stdin
  def get_input
    $stdin.readline().chomp
  end

end

Application.new.run
