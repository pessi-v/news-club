class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :author
      t.datetime :date
      t.string :source

      t.timestamps
    end
  end
end
