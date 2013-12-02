class CreatePost < ActiveRecord::Migration
  def self.up
    create_table :posts do |p|
      p.string :title
      p.text :body
      p.timestamps
      p.references :user
      p.references :comment
    end
  end

  def down
    drop_table :posts
  end
end
