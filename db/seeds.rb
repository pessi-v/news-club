#Thisfileshouldcontainalltherecordcreationneededtoseedthedatabasewithitsdefaultvalues.
#Thedatacanthenbeloadedwiththerailsdb:seedcommand(orcreatedalongsidethedatabasewithdb:setup).
#
#Examples:
#
#movies=Movie.create([{name:'StarWars'},{name:'LordoftheRings'}])
#Character.create(name:'Luke',movie:movies.first)

plan1=Plan.create(amount:10,price_cents:500)
plan2=Plan.create(amount:25,price_cents:1000)
plan3=Plan.create(amount:500,price_cents:1000)

Reading.destroy_all
User.destroy_all
Subscription.destroy_all
new_test_user=User.new(first_name:"test",last_name:"person",email:"test@email.com",password:"123123")
new_test_user.publication_list.add("the-guardian","new-scientist")
new_test_user.writer_list.add("SamMintz")
new_test_user.theme_list.add("space","climate","beer","mushroom")
new_test_user.save!

Subscription.create(plan_id:3,user:new_test_user)

url='https://newsapi.org/v2/everything?'\
'sources=australian-financial-review,daily-mail,financial-times,independent,mirror,the-globe-and-mail,
the-hindu,the-irish-times,the-jerusalem-post,the-new-york-times,the-telegraph,
the-times-of-india,usa-today,the-wall-street-journal,the-washington-post,the-washington-times,business-insider,business-insider-uk,entertainment-weekly,financial-post,fortune,national-geographic,national-review,the-huffington-post,
new-scientist,newsweek,new-york-magazine,politico,the-economist,the-hill,time,vice-news,abc-news,abc-news-au,al-jazeera-english,ars-technica,associated-press,axios,
bleacher-report,bloomberg,buzzfeed,cnbc,cnn,crypto-coins-news,engadget,espn,
espn-cric-info,football-italia,four-four-two,ign,mashable,medical-news-today,
msnbc,nbc-news,news24,news-com-au,next-big-future,nfl-news,nhl-news,polygon,
recode,reuters,rte,techcrunch,techradar,the-next-web,the-sport-bible,the-verge'\
'from=2019-02-15&'\
'sortBy=publishedAt&'\
"apiKey=#{ENV['NEWSAPI_API_KEY2']}&"\
"pageSize=400"

req=open(url)
response_body=req.read
articles_json=JSON.parse(response_body)
articles_array=articles_json["articles"]
last_articles=[]
articles_array.eachdo|a|
article=Article.find_by(title:a["title"])
unlessarticle#checkifarticleisalreadyinthedatabase
article=Article.new(title:a["title"],author:a["author"]||a["source"],source:a["source"]["name"],url:a["url"],date:a["publishedAt"],content:a["content"]||"nocontentavailable",image:a["urlToImage"],description:a["description"])
article.publication_list.add(a["source"]["id"])
extractor=Phrasie::Extractor.new
tagging=extractor.phrases(a["content"],occur:1)
tags=tagging.each{|p|p[0]}
article.theme_list.add(tags)
article.save!
end
last_articles<<article
end
