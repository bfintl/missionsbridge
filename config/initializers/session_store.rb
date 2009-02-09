# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_missionsbridge_session',
  :secret      => '6b0b6ac0d149871a49de97637a8df620ac9fc3c48a9f25eddc8211336a991a9b24e0067cadc470746bc74757e1fa618869959caf05bb11f274123baf35e17c37'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
