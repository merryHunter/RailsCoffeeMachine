Ruby on Rails v. 3.2.3
Customer can order a drink, add money to bill and in case of lack of money the transaction will not be performed.
Administrator can perform CRUD operations for drinks, view orders and registered users.
Web-site is internationalized and supports 2 languages - English and Ukrainian.

![alt tag] (https://github.com/merryHunter/RailsCoffeeMachine/blob/master/Coffee_machine.png)

Run:
bundle install

Development mode:
bundle exec rake db:migrate  -- sqlite migrations
rails s -- start server

Production mode:(check db properties in database.yml)
bundle exec rake db:setup RAILS_ENV="production"
rails s -e production
