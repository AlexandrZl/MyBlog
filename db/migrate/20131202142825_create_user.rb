class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :email
    end
  end

  def down
    drop_table :users
  end
end
