require_relative 'contact'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # todo: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  attr_accessor :command

  def initialize(command)
    @command = command
    #params.each {|key,value| instance_variable_set("@#{key}",value)}
  end

  def execution_option
    #binding.pry
    if @command.nil?
      self.main_menu
    end
    case (@command)
    when 'new'

    when 'list'
      puts Contact.all
    when 'show'
    when 'search'

    end

  end

  def main_menu
    puts "Here is a list of available commands:"
    puts "new    - Create a new contact"
    puts "list   - List all contacts"
    puts "show   - Show a contact"
    puts "search - Search contacts"
  end
end

contacts = ContactList.new(ARGV[0])
contacts.execution_option
