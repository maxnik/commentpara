# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_commentpara_session',
  :secret      => '7b586614b6e4daeb591b59603605084c99aa9772731d7c7c4e40781493e2dfcc57a0401ea4d72bcc687f52cda0ed8568828aef5459cb95c315edffc2265a69b5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
