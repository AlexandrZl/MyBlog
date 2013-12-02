class CreateComment < ActiveRecord::Migration
  def self.up
    create_table :comments do |c|
      c.string :title
      c.text :body
      c.timestamps
      c.belongs_to :post
      c.integer :post_id
      c.string :user_name
      c.references :user
    end
  end

  def down
    drop_table :comments
  end
end
