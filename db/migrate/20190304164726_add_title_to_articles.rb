class AddTitleToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :title, :string, null: false
  end
end
