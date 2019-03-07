class PreferencesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index]

  def index
    @user = current_user
  end

  def update
    mmmmhash = params.to_unsafe_h
    # puts mmmmhash
    tag_arr = []
    mmmmhash.select { |k, v| v == "on" }.keys.each { |k| tag_arr << k }
    # puts "-------------"
    # puts tag_arr
    # puts "-------------"
    current_user.publication_list.add(tag_arr)
    current_user.save!
  end
end
