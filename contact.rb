require 'csv'
require 'pg'
require 'pry'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :id, :first_name, :last_name, :phone1,:phone2, :email
  @@conn

  # Creates a new contact object
  # param id [Integer] The contact's id
  # param first_name [String] The contact's first name
  # param last_name [String] The contact's last name
  # param phone1 [String] The contact's first phone number
  # param phone1 [String] The contact's second phone number
  # param email [String] The contact's email address
  def initialize(params = {})
    # todo: Assign parameter values to instance variables.
    params.each {|key,value| instance_variable_set("@#{key}",value)}
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    def connection
        puts 'Connecting to DB...'
        @@conn = PG.connect(
          host: 'localhost',
          dbname: 'contactlist',
          user: 'postgres',
          password: 'postgres'
        )
    end

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # return [Array<Contact>] Array of Contact objects
    def all
      # todo: Return an Array of Contact instances made from the data in 'contacts.csv'.
      contacts=[]
      contact_list_hash = []
      connection
      puts 'Finding Contacts...'
      results = @@conn.exec('select * from contacts;').each { |contact|
          contact_list_hash << contact
        }

      @@conn.close
      contact_list_hash.each {|contact| contacts << Contact.new({id:contact['id'],first_name: contact['first_name'],last_name: contact['last_name'], phone1:contact['phone1'], phone2:contact['phone2'] , email:contact['email']})}
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # param name [String] the new contact's name
    # param email [String] the contact's email
    def create(params={})
      # todo: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contact = Contact.new(params)
      save(contact)
    end

    def save(contact)

      puts 'Searching DB for record...'
      found_contact = find(contact.id)
      if found_contact.nil?
        puts 'Inserting into DB...'
        # new_id = @@conn.exec("select Max(id) from contacts;").to_i + 1
        connection
        @@conn.exec("INSERT INTO contacts(first_name,last_name,phone1,phone2,email) VALUES ('#{contact.first_name}','#{contact.last_name}','#{contact.phone1}','#{contact.phone2}','#{contact.email}');")
        @@conn.close
      else
        puts "Updating record id = #{contact.id} into DB..."
        connection
        @@conn.exec("UPDATE contacts SET first_name='#{contact.first_name}',last_name='#{contact.last_name}',phone1='#{contact.phone1}',phone2 ='#{contact.phone2}',email='#{contact.email}' WHERE id =#{contact.id};")
        @@conn.close
      end

    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # param id [String] the contact id
    # return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # todo: Find the Contact in the 'contacts.csv' file with the matching id.
      connection
      results = @@conn.exec("SELECT * from contacts where id = #{id}")
      @@conn.close
      contact = Contact.new({id:results[0]['id'].to_i,first_name: results[0]['first_name'],last_name: results[0]['last_name'], phone1:results[0]['phone1'], phone2:results[0]['phone2'] , email:results[0]['email']}) unless results.cmd_tuples.zero?
      return contact
    end

    # Search for contacts by either name or email.
    # param term [String] the name fragment or email fragment to search for
    # return [Array<Contact>] Array of Contact objects.
    def search(term)
      # todo: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      found_contacts = []
      connection
      results = @@conn.exec("SELECT * from contacts where first_name like '%#{term}%' or last_name like '%#{term}%' or email like '%#{term}%';")
      @@conn.close
      #test if term is in first_name, last_name, or email
      results.each {|contact|
        found_contacts << Contact.new({id:contact['id'].to_i,first_name: contact['first_name'],last_name: contact['last_name'], phone1:contact['phone1'], phone2:contact['phone2'] , email:contact['email']})

      } unless results.cmd_tuples.zero?
      found_contacts
    end

    def update(contact)
      create(contact)
    end

    def destroy(contact)
      connection
      @@conn.exec("DELETE from contacts WHERE id = #{contact.id}")
      @@conn.close
      puts 'Done...'
    end

    def find_by_name(name)
      search(term)
    end

    def find_by_email(email)
      search(term)
    end

  end

end

# Contact.create({id:501,first_name: 'foo',last_name: 'bar', phone1:'4165362782', phone2:'4165965823' ,email:'test@gmail.com'})
