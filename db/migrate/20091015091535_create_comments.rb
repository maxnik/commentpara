class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :author, :null => false
      t.string :url
      t.text :body, :null => false
      t.integer :chapter_id
      t.integer :commentable_id
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
