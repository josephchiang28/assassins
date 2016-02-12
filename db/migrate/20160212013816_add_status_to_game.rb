class AddStatusToGame < ActiveRecord::Migration
  def change
    add_column :games, :status, :string, null: false, default: 'inactive'
  end
end
