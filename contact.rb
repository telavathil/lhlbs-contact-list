require_relative 'config.rb'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class Contact < ActiveRecord::Base
  validates :email, presence: true, email: true
  has_many :phone
end

binding.pry
