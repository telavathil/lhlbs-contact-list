require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
    # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
    attr_reader :command, :arg1

    def initialize(command, arg1)
        @command = command
        @arg1 = arg1
        # params.each {|key,value| instance_variable_set("@#{key}",value)}
    end

    def execution_option
        main_menu if @command.nil?

        case @command
        when 'new','update'
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
               if @command == 'new'
                 input[:id] = 0
                 Contact.create(input)
               elsif @command == 'update'
                 input[:id] = @arg1
                 Contact.update(input)
               end
            # rescue
            #    puts 'An error has occured please try again'
            #end
           end
        # print 'This email is has already been used. Please provide another email.'

        when 'list'
          continue = true
          offset = 0
          while continue
            list_and_total = Contact.all(offset)
            total_rows = list_and_total[1]
            list = list_and_total[0]
            list.each_with_index {|contact,index|
              puts "#{index}: #{list[index].first_name} #{list[index].last_name} (#{list[index].email})"
            }
            puts "Viewing records #{offset} to #{offset + 10} of #{total_rows} total records"
            #pagination
            puts "Do you wish to see another page? y/n"
            print "y/n: "
            choice = STDIN.gets.chomp
            if choice == 'n'
              continue = false
            else
              offset += 10
            end
          end

        when 'show', 'delete'
          puts 'Please provide the id for this contact. Ids are integers'
          print 'ID: '
          uid = STDIN.gets.chomp
          contact = Contact.find(uid)
          #binding.pry
          if contact.nil?
            puts "There is no record with #{uid} as as an id."
          elsif @command == 'show'
            puts "Here are the contacts details"
            puts "First Name: #{contact.first_name}"
            puts "Last Name: #{contact.last_name}"
            puts "Primary Phone Number: #{contact.phone1}"
            puts "Secondary Phone Number: #{contact.phone2}"
            puts "Email address: #{contact.email}"
          elsif @command == 'delete'
            puts "The contact at #{uid} will be deleted..."
            Contact.destroy(contact)
          end
        when 'search'
          puts 'Please provide the search term you would like search for. '
          print 'Search for: '
          term = STDIN.gets.chomp
          list = Contact.search(term)
          #binding.pry
          if list.empty?
            puts "No contact matched that search term"
          else
            puts "These are the records that matched that search."
            list.each_with_index {|contact,index|
                puts "#{index}: #{list[index].first_name} #{list[index].last_name} (#{list[index].email})"
            }
          end
        else
          puts "That is not a valid command" unless @command.nil?
        end
    end

    def main_menu
        puts 'Here is a list of available commands:'
        puts 'new    - Create a new contact'
        puts 'list   - List all contacts'
        puts 'show   - Show a contact'
        puts 'search - Search contacts'
        puts 'update  - Update a contact with a given id'
        puts 'delete  - Delete a contact with a given id'
    end
end

contacts = ContactList.new(ARGV[0], ARGV[1])
contacts.execution_option
