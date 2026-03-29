# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Custom fields
      t.string  :first_name, null: false
      t.string  :last_name,  null: false
      t.integer :role,       null: false, default: 0

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :role
  end
end
