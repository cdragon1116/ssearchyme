Dir.glob('./app/{models}/*.rb').each { |file| require file }


# require_relative '../models/user.rb'

users = [
  {name: 'Jon',email: 'e@example.com'},
  {name: 'Jane',email: 'e@example.com'}
]

users.each do |u|
  User.new(u).save
end