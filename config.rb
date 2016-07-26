require "active_record"
require 'pry'
require 'pg'

#setup logger
ActiveRecord:Base.logger = ActiveSupport::Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'contactlist'
)

ActiveRecord::Schema.define {
  create_table :contacts { |t|
    t.string :first_name, null: false
    t.string :last_name, null: false
    t.string :email null: false
  }

  create_table :phones { |t|
    t.references :product, null: false, index:true, foreign: true
    t.number
  }
}
