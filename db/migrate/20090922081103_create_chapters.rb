class CreateChapters < ActiveRecord::Migration
  def self.up
    create_table :chapters do |t|
      t.string :title, :null => false
      t.text :body
      t.text :body_html
      t.timestamps
    end
  end

  def self.down
    drop_table :chapters
  end
end
