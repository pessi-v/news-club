class AddUrlToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :url, :string, null: false
  end
end
