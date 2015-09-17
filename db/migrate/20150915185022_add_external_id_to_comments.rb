class AddExternalIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :external_id, :string
  end
end
