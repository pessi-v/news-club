class AddContentToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :content, :text, null: false
    add_column :articles, :image, :string
  end
end
