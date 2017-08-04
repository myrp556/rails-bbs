# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: "name", user_name: "zhangsan", mail: "y123@163.con", \
           number: 0,
           password: "12345678", password_confirmation: "12345678")

Zone.create(name: "zone000", description: "this is a short description")
