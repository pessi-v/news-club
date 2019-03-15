require 'open-uri'
require 'json'

class ArticlesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index]

  def index
    @articles = fetch_articles
    @plan1 = Plan.find(1)
    @plan2 = Plan.find(2)
  end

  def show
    @article = Article.find(params[:id])
    if current_user.subscription && (current_user.readings.length > current_user.subscription.plan.amount)
      @allow = false
    else
      @allow = true
      unless current_user.readings.find_by(article_id: @article.id) # don't create a new reading if user already has read this article
        @current_reading = Reading.new(user: current_user, article: @article)
        @current_reading.save!
        @snackbar = true
      end
    end
  end

  def home

    @all_user_articles = Article.tagged_with(current_user.publication_list, any: true)
    @latest = @all_user_articles.where(date: DateTime.parse('2019-03-14'))
    # @all_user_articles = Article.all.shuffle
    @user_read_articles = []
    current_user.readings.each do |reading|
      @user_read_articles << Article.find(reading.article_id)
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :author, :date, :source, :tag_list) ## Rails 4 strong params usage
  end

  def fetch_articles
    url = 'https://newsapi.org/v2/top-headlines?'\
      'from=2019-03-14&'\
      'sources=associated-press,bild,business-insider,business-insider,daily-mail,der-tagesspiegel,die-zeit,entertainment-weekly,espn,financial-post,financial-times,focus,fortune,national-geographic,new-scientist,newsweek,new-york-magazine,politico,polygon,reuters,spiegel-online,techcrunch,techradar,the-economist,the-globe-and-mail,the-hill,the-huffington-post,the-new-york-times,the-wall-street-journal,the-washington-times,time,wired&'\
      'sortBy=publishedAt&'\
      "apiKey=#{ENV['NEWSAPI_API_KEY']}&"\
      "pageSize=40"

    req = open(url)
    response_body = req.read
    articles_json = JSON.parse(response_body)
    articles_array = articles_json["articles"]
    last_articles = []
    articles_array.each do |a|
      article = Article.find_by(title: a["title"])
      article2 = Article.find_by(url: a["url"])
      unless article || article2 # check if article is already in the database or
        author  = a["author"].blank? ? a["source"]["name"] : a["author"]
        article = Article.new(title: a["title"], author: author, source: a["source"]["name"], url: a["url"], date: a["publishedAt"], content: a["content"] || "no content available", image: a["urlToImage"], description: a["description"])
        article.publication_list.add(a["source"]["id"])
        # extractor = Phrasie::Extractor.new
        # tagging = extractor.phrases(a["content"], occur: 1)
        # tags = tagging.each { |p| p[0] }
        # article.theme_list.add(tags)
        article.save!
      end
      last_articles << article
    end
    last_articles.compact

  end
  # REDIRECT TO SIGN UP WHEN TRYING TO READ AN ARTICLE BEFORE TO CREATE AN ACCOUNT !!
  # WE COULD CANCEL AFTER THE DEMODAY
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_registration_path
    end
  end
end

