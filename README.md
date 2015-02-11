# dochive 
### by Queen Anne's Revenge: Open Source Skunkworks

This version of DocHive introduces many new features. It is still a work in progress, however, it is very functional. Today my second son Lucien will be born, so I better start sharing this code :)

	What can you do:
	Signup for an account
	Click on Files
	Upload a document and click convert. 
	Upload a document and create new templates for your pages, then convert.


## Buggy Notes: 

You will need to refresh on the Files and Data pages to see updates.
This version is designed to strictly support imaged based PDFs. 
On Linux the /tmp file may not remove generated Magick files. Manual cleanup periodically may be required.
PDF images are currently expected in a Portrait style, Landscape images may be distorted.
Data exported may appear in duplicates if you are using the default 'selfie' template.

## Ruby version

	Ruby 2.0.0p247

## System dependencies

	RMagick
	Tesseract 
	MySQL

## Configuration

Install the Tesseract language packages needed 

## Database creation

	1. create dochive_mysql_development in MySQL

## Database initialization

	1. Rename the file '/config/default.database.yml' to '/config/database.yml' and update your database user, password, and any other relavant settings.

	2. Build the table structure
		bundle exec rake db:migrate RAILS_ENV=development

	3. Seed the database
		bundle exec rake db:seed

## How to run the application and background queues

	In terminal #1 execute the following to run the rails applications

		rails s 

	In terminal #2 execute the following command to start the background worker job. 

		bundle exec rake jobs:work

## Deployment instructions

On Linux uncomment the line in the gemfile for therubyracer

	gem 'therubyracer', platforms: :ruby



