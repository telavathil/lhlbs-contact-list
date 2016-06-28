require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
    # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
    attr_accessor :command

    def initialize(command)
        @command = command
        # params.each {|key,value| instance_variable_set("@#{key}",value)}
    end

    def execution_option
        # binding.pry
        main_menu if @command.nil?

        case @command
        when 'new'
            input = {}
            puts 'Please provide a first name, last name, primary and secondary phone numbers and an email address for this contact.'
            print 'First Name: '
            input[:first_name] = STDIN.gets.chomp
            print 'Last Name: '
            input[:last_name] = STDIN.gets.chomp
            print 'Primary Phone Number: '
            input[:phone1] = STDIN.gets.chomp
            print 'Secondary Phone Number: '
            input[:phone2] = STDIN.gets.chomp
            print 'Email address: '
            input[:email] = STDIN.gets.chomp

            begin
               #binding.pry
               Contact.create(input)
            rescue
               puts 'An error has occured please try again'
            end
        # print 'This email is has already been used. Please provide another email.'

        when 'list'
            list = Contact.all
            binding.pry
            list.each_with_index {|contact,index|
              puts "#{index}: #{list[index].first_name} #{list[index].last_name} (#{list[index].email})"
            }
            puts "#{list.length} records total"

        when 'show'
          puts 'Please provide the uid for this contact. The uids for the contacts are 8 letters, all caps. eg. PFFJNLSM '
          print 'UID: '
          uid = STDIN.gets.chomp
          contact = Contact.find(uid)
          binding.pry
          if contact.nil?
            puts "There is no record with #{uid} as as an id."
          else
            puts "Here are the contacts details"
            puts "First Name: #{contact.first_name}"
            puts "Last Name: #{contact.last_name}"
            puts "Primary Phone Number: #{contact.phone1}"
            puts "Secondary Phone Number: #{contact.phone2}"
            puts "Email address: #{contact.email}"
          end
        when 'search'
          puts 'Please provide the search term you would like search for. '
          print 'Search for: '
          term = STDIN.gets.chomp
          list = Contact.search(term)
          binding.pry
          if list.empty?
            puts "No contact matched that search term"
          else
            puts "These are the records that matched that search."
            list.each_with_index {|contact,index|
                puts "#{index}: #{list[index].first_name} #{list[index].last_name} (#{list[index].email})"
            }
          end
        else
          puts "That is not a valid command"
        end
    end

    def main_menu
        puts 'Here is a list of available commands:'
        puts 'new    - Create a new contact'
        puts 'list   - List all contacts'
        puts 'show   - Show a contact'
        puts 'search - Search contacts'
    end
end

contacts = ContactList.new(ARGV[0])
contacts.execution_option
