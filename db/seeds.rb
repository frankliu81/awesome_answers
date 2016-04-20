# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create(first_name: 'Frank', last_name: 'Liu', email: 'frankliu81@gmail.com',
              password: 'bu', password_confirmation: 'bu')

admin_user = User.create(first_name: 'Admin', last_name: 'Admin',
              email: 'admin@admin.com', password: 'admin',
              password_confirmation: 'admin', admin: true)



10.times do
  Category.create(name: Faker::Hacker.adjective)
end

all_categories = Category.all
cateogories_count = all_categories.count

30.times do
  q = Question.create  title: Faker::Company.bs,
                      body: Faker::Lorem.paragraph,
                      view_count: 0

  5.times do
    # q.answers is an ActiveRecord::Relation, you can also call create on it
    a = q.answers.new(body: Faker::StarWars.quote)
    a.user = u;
    a.save
  end

  random_category = all_categories.sample
  q.category = random_category
  q.user = u
  q.save

end


# puts Cowsay.say("Generated a 100 quesitons!")
