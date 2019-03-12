# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

plan1 = Plan.create(amount: 10, price_cents: 500)
plan2 = Plan.create(amount: 25, price_cents: 1000)
plan3 = Plan.create(amount: 500, price_cents: 1000)

Reading.destroy_all
User.destroy_all
Subscription.destroy_all
new_test_user = User.new(first_name:"test", last_name:"person", email:"test@email.com", password:"123123")
new_test_user.publication_list.add("the-guardian", "new-scientist")
new_test_user.writer_list.add("Sam Mintz")
new_test_user.theme_list.add("space", "climate", "beer", "mushroom")
new_test_user.save!

Subscription.create(plan_id: 3, user: new_test_user)

# url = 'https://newsapi.org/v2/everything?'\
#   'q=forest OR mushroom OR summer OR flowers OR rojava OR techno OR sanders OR corbyn OR beer OR whisky OR anarchist OR&'\
#   'sources=ars-technica,associated-press,bild,bloomberg,business-insider,business-insider,daily-mail,der-tagesspiegel,die-zeit,entertainment-weekly,espn,financial-post,financial-times,focus,fortune,gruenderszene,mirror,national-geographic,new-scientist,newsweek,new-york-magazine,politico,polygon,reuters,spiegel-online,techcrunch,techradar,the-economist,the-globe-and-mail,the-guardian-uk,the-hill,the-huffington-post,the-new-york-times,the-telegraph,the-verge,the-wall-street-journal,the-washington-times,time,wired,le-monde,liberation,la-repubblica' \
#   'from=2019-03-01&'\
#   'sortBy=publishedAt&'\
#   "apiKey=#{ENV['NEWSAPI_API_KEY2']}&"\
#   "pageSize=300"

# req = open(url)
# response_body = req.read
# articles_json = JSON.parse(response_body)
# articles_array = articles_json["articles"]
# last_articles = []
# articles_array.each do |a|
#   article = Article.find_by(title: a["title"])
#   unless article # check if article is already in the database
#     article = Article.new(title: a["title"], author: a["author"] || a["source"], source: a["source"]["name"], url: a["url"], date: a["publishedAt"], content: a["content"] || "no content available", image: a["urlToImage"], description: a["description"])
#     article.publication_list.add(a["source"]["id"])
#     extractor = Phrasie::Extractor.new
#     tagging = extractor.phrases(a["content"], occur: 1)
#     tags = tagging.each { |p| p[0] }
#     article.theme_list.add(tags)
#     article.save!
#   end
#   last_articles << article
# end
