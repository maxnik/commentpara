namespace :users do  
  desc "This task will delete all users and create a new one"
  task (:create => :environment) do
    User.destroy_all
    user = User.create!(:email => ENV["EMAIL"],
                        :password => ENV["PASSWORD"],
                        :password_confirmation => ENV["PASSWORD"])
  end
end 
