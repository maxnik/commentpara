class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :email,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :perishable_token,    :null => false      
      t.timestamps
    end

    u = User.new(:email => 'maxim.nikolenko@gmail.com', 
                 :password => 'password',
                 :password_confirmation => 'password')
    u.save!
  end

  def self.down
    drop_table :users
  end
end
