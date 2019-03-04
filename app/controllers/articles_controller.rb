class ArticlesController < ApplicationController


  private

  def user_params
    params.require(:article).permit(:title, :author, :date, :source, :tag_list) ## Rails 4 strong params usage
  end

end
