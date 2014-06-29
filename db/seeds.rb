# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


account1 = Account.create(email: "a1@email.com", password: "defaultpw")
account1.create_profile(first_name: "a1", last_name: "a1")
account2 = Account.create(email: "a2@email.com", password: "defaultpw")
account2.create_profile(first_name: "a2", last_name: "a2")