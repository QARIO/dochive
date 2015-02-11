# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
DochiveMysql::Application.config.secret_key_base = '6d53948a0ed8c86de5c89195fee463a4e20aee948b5b8b2927c12f238f354b304d01ceb7ecd02c3b9b85d9f44ac98264184cffff1177fd122b160813aa0ace02'
