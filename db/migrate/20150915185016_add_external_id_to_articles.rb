class AddExternalIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :external_id, :string
  end
end
