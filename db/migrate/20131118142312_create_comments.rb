class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string :title
      t.text :body
      t.timestamps
    end
    Comment.create(title: "My first post", body: "And this is the post's content.")
  end
 
  def down
    drop_table :comments
  end
end
