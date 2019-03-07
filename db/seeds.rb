# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

 plan1 = Plan.create(amount: 10, price_cents: 500)
 plan2 = Plan.create(amount: 25, price_cents: 1000)

Reading.destroy_all
User.destroy_all
Subscription.destroy_all
 new_test_user = User.new(first_name:"test", last_name:"person", email:"test@email.com", password:"123123")
 new_test_user.publication_list.add("the-guardian", "new-scientist")
 new_test_user.writer_list.add("Sam Mintz")
 new_test_user.theme_list.add("space", "climate", "beer", "mushroom")
 new_test_user.save!

 Subscription.create(plan_id: 2, user: new_test_user)
