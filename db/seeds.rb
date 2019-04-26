
plan1 = Plan.create(amount:10,price_cents:500)
plan2 = Plan.create(amount:25,price_cents:1000)
# plan3 = Plan.create(amount:500,price_cents:1000)
require 'date'


#Reading.destroy_all
#Article.destroy_all

# Subscription.destroy_all
# User.destroy_all

# new_test_user = User.new(first_name:"best",last_name:"person",email:"best@email.com",password:"123123")
# new_test_user.publication_list.add("financial-times","the-new-york-times","the-telegraph",
# "the-times-of-india","the-wall-street-journal","the-washington-times","business-insider","financial-post","fortune","national-geographic","the-huffington-post",
# "new-scientist","newsweek","new-york-magazine","politico","the-economist")
# # new_test_user.writer_list.add("SamMintz")
# new_test_user.theme_list.add("space","climate","beer","mushroom")
# new_test_user.save!

# another_test_user = User.new(first_name:"james",last_name:"bauer",email:"blank@email.com",password:"123123")
# # another_test_user.theme_list.add("space","climate","beer","mushroom")
# another_test_user.save!

# Subscription.create(plan_id:3,user:new_test_user)
# Subscription.create(plan_id:2,user:another_test_user)


def fetch_articles(url)
  req = open(url)
  response_body = req.read
  articles_json = JSON.parse(response_body)
  articles_array = articles_json["articles"]
  last_articles = []
  articles_array.each do |a|
    article = Article.find_by(title:a["title"])
    unless article #check if article is already in the database
      author  = a["author"].blank? ? a["source"]["name"] : a["author"]
      article = Article.new(title:a["title"],author: author,source:a["source"]["name"],url:a["url"],date:a["publishedAt"],content:a["content"] || "no content available",image:a["urlToImage"],description:a["description"])
      article.publication_list.add(a["source"]["id"])
    # extractor = Phrasie::Extractor.new
    # tagging = extractor.phrases(a["content"],occur:1)
    # tags = tagging.each{|p|p[0]}
    # article.theme_list.add(tags)
      article.save!
    end
  end
end


url = "https://newsapi.org/v2/top-headlines?sources=australian-financial-review,daily-mail,financial-times,independent,mirror,the-globe-and-mail,the-hindu,the-irish-times,the-jerusalem-post,the-new-york-times,the-telegraph,the-times-of-india,usa-today,the-wall-street-journal,the-washington-post,the-washington-times,business-insider,business-insider-uk,entertainment-weekly,financial-post,fortune,national-geographic,national-review,the-huffington-post,new-scientist,newsweek,new-york-magazine,politico,the-economist,the-hill,time,vice-news,abc-news,abc-news-au,al-jazeera-english,ars-technica,associated-press,axios,bleacher-report,bloomberg,buzzfeed,cnbc,cnn,crypto-coins-news,engadget,espn,espn-cric-info,football-italia,four-four-two,ign,mashable,medical-news-today,msnbc,nbc-news,news24,news-com-au,next-big-future,nfl-news,nhl-news,polygon,recode,reuters,rte,techcrunch,techradar,the-next-web,the-sport-bible,the-verge&from=#{Date.today-1}&sortBy=publishedAt&apiKey=#{ENV['NEWSAPI_API_KEY']}&pageSize=50"
fetch_articles(url)

url = "https://newsapi.org/v2/top-headlines?sources=australian-financial-review,daily-mail,financial-times,independent,mirror,the-globe-and-mail,the-hindu,the-irish-times,the-jerusalem-post,the-new-york-times,the-telegraph,the-times-of-india,usa-today,the-wall-street-journal,the-washington-post,the-washington-times,business-insider,business-insider-uk,entertainment-weekly,financial-post,fortune,national-geographic,national-review,the-huffington-post,new-scientist,newsweek,new-york-magazine,politico,the-economist,the-hill,time,vice-news,abc-news,abc-news-au,al-jazeera-english,ars-technica,associated-press,axios,bleacher-report,bloomberg,buzzfeed,cnbc,cnn,crypto-coins-news,engadget,espn,espn-cric-info,football-italia,four-four-two,ign,mashable,medical-news-today,msnbc,nbc-news,news24,news-com-au,next-big-future,nfl-news,nhl-news,polygon,recode,reuters,rte,techcrunch,techradar,the-next-web,the-sport-bible,the-verge&from=#{Date.today-2}&sortBy=publishedAt&apiKey=#{ENV['NEWSAPI_API_KEY']}&pageSize=20"
fetch_articles(url)

url = "https://newsapi.org/v2/everything?sources=financial-times,the-new-york-times,the-telegraph,the-wall-street-journal,the-washington-post,the-washington-times,business-insider,business-insider-uk,entertainment-weekly,financial-post,fortune,national-geographic,new-scientist,newsweek,new-york-magazine,the-economist,time,vice-news,associated-press,wired&from=#{Date.today-3}&sortBy=publishedAt&apiKey=#{ENV['NEWSAPI_API_KEY']}&pageSize=20"
fetch_articles(url)

url = "https://newsapi.org/v2/top-headlines?sources=the-new-york-times,the-wall-street-journal,financial-post,national-geographic,the-huffington-post,new-scientist,newsweek,new-york-magazine,politico,time,vice-news,wired&from=#{Date.today-4}&sortBy=publishedAt&apiKey=#{ENV['NEWSAPI_API_KEY']}&pageSize=40"
fetch_articles(url)
