class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :email
      
    end
    User.create(name: "Alex", password: "11", email: "11@yandex.ru")
  end

  def down
    drop_table :users
  end
end
