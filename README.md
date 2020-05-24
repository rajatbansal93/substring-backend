# README

This is the backend for string calculations. Steps to run the app server are:

1. Run `bundle install`
2. Install PSQL if not already present in system.
3. run `rails db:setup`
4. Run `rails s -p 5000`. Please note frontend application by default assume server running on
port 5000. If you want to use any other port then please update front end app accordingly.

To run all the specs run `rspec spec`.