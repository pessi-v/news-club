class AddContentToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :content, :text, null: false
    add_column :articles, :image, :string
    add_column :articles, :description, :string
  end
end
