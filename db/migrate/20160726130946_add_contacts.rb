class AddContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone1
      t.string :phone2
      t.string :email
    end
  end
end
