class CreateUserPostComment < ActiveRecord::Migration
def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.timestamps
      t.references :user
    end

      create_table :comments do |t|
      t.string :title
      t.text :body
      t.timestamps
      t.belongs_to :post
      t.integer :post_id
      t.string :user_name
      t.references :user
    end


      create_table :users do |t|
      t.string :name
      t.string :password
      t.string :email
    end
    User.create(name: "Alex", password: "11", email: "11@yandex.ru")
  end
 
  def self.down
    drop_table :posts
    drop_table :comments
    drop_table :users
  end
end