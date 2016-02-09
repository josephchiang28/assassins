class AddNotNulltoGames < ActiveRecord::Migration
  def change
    change_column :games, :name, :string, null: false
    change_column :games, :passcode, :string, null: false
  end
end
