require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :id, :first_name, :last_name, :phone1,:phone2, :email

  # Creates a new contact object
  # param id [String] The contact's id
  # param first_name [String] The contact's first name
  # param last_name [String] The contact's last name
  # param phone1 [String] The contact's first phone number
  # param phone1 [String] The contact's second phone number
  # param email [String] The contact's email address
  def initialize(params = {})
    #generate contact id
    @id = (0...8).map { (65 + rand(26)).chr }.join
    # todo: Assign parameter values to instance variables.
    params.each {|key,value| instance_variable_set("@#{key}",value)}
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # return [Array<Contact>] Array of Contact objects
    def all
      # todo: Return an Array of Contact instances made from the data in 'contacts.csv'.
      contacts=[]
      contact_list = CSV.read('/home/tobin/Projects/lighthouse/contact-list/contacts1.csv')
      contact_list.each {|contact| contacts << Contact.new({first_name: contact[1],last_name: contact[2], phone1:contact[3], phone2:contact[4] , email:contact[5]})}
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # param name [String] the new contact's name
    # param email [String] the contact's email
    def create(params={})
      # todo: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contact = Contact.new(params)
      contact_row = [contact.id,contact.first_name,contact.last_name,contact.phone1,contact.phone2,contact.email]
      CSV.open('/home/tobin/Projects/lighthouse/contact-list/contacts1.csv', 'a') {|csv| csv << contact_row}
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # param id [String] the contact id
    # return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # todo: Find the Contact in the 'contacts.csv' file with the matching id.
      contact_list = CSV.read('/home/tobin/Projects/lighthouse/contact-list/contacts1.csv')
      contact_list.each {|contact|
        if contact[0] == id
          return Contact.new({first_name: contact[1],last_name: contact[2], phone1:contact[3], phone2:contact[4] ,email:contact[5]})
        end
      }
      return nil
    end

    # Search for contacts by either name or email.
    # param term [String] the name fragment or email fragment to search for
    # return [Array<Contact>] Array of Contact objects.
    def search(term)
      # todo: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      found_contacts = []
      contact_list = CSV.read('/home/tobin/Projects/lighthouse/contact-list/contacts1.csv')
      #test if term is in first_name, last_name, or email
      contact_list.each {|contact|
        if [contact[1].to_s, contact[2].to_s,contact[5].to_s].inject(false){|match,word| match || word.match(term) }
          found_contacts << Contact.new({first_name: contact[1],last_name: contact[2], phone1:contact[3], phone2:contact[4] , email:contact[5]})
        end
      }
      found_contacts
    end

  end

end
