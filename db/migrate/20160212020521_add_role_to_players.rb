class AddRoleToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :role, :string, null: false
    remove_column :players, :gamemaker, :boolean
    remove_column :players, :spectator, :boolean
  end
end
