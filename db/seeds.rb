# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 100.times do
#   q = Question.create  title: Faker::Company.bs,
#                       body: Faker::Lorem.paragraph,
#                       view_count: 0
#
#   10.times do
#     # q.answers is an ActiveRecord::Relation, you can also call create on it
#     q.answers.create(body: Faker::StarWars.quote)
#   end
#
# end

10.times do
  Category.create(name: Faker::Hacker.adjective)
end

# puts Cowsay.say("Generated a 100 quesitons!")
