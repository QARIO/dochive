# dochive 
#### by Queen Anne's Revenge: Open Source Skunkworks

This version of DocHive introduces many new features. It is still a work in progress, however, it is very functional. 

	What can you do:
	Upload a image based pdf and click convert. OCR each page.
	Upload a image based pdf and create new templates for your pages, then convert. OCR only select regions.
	
	Test with the include file "UN Report-28th Session-1973.pdf"

### Ruby version

	Ruby 2.0.0p247

### System dependencies

	RMagick
	Tesseract 
	MySQL

### Configuration

Install the Tesseract language packages needed 

### Database creation

Create dochive_mysql_development in MySQL

### Database initialization

Rename the file '/config/default.database.yml' to '/config/database.yml' and update your database user, password, and any other relavant settings.

Build the table structure

	bundle exec rake db:migrate RAILS_ENV=development

Seed the database

	bundle exec rake db:seed

### How to run the application and background queues

In terminal #1 execute the following to run the rails applications

	rails s 

In terminal #2 execute the following command to start the background worker job. 

	bundle exec rake jobs:work

### Linux Deployment instructions

In the gemfile, uncomment the line for therubyracer

	gem 'therubyracer', platforms: :ruby
	
In the /app/controllers/documents_controller.rb, 
uncomment line 7, comment out line 6

	#require 'Gchart'
  	require 'googlecharts' 

### Buggy Notes: 

You will need to refresh on the Files and Data pages to see updates.
This version is designed to strictly support imaged based PDFs. 
On Linux the /tmp file may not remove generated Magick files. Manual cleanup periodically may be required.
PDF images are currently expected in a Portrait style, Landscape images may be distorted.
Data exported may appear in duplicates if you are using the default 'selfie' template.

### Initial Release on 11 February 2015
A few hour later Lucien Shoa Brian Duncan was born.
