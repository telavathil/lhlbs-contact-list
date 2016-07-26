require 'activerecord'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Phone < ActiveRecord::Base
  belongs_to :contact
end
