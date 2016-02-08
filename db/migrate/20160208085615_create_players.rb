class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id, null: false, index: true
      t.integer :game_id, null: false, index: true
      t.string  :nickname
      t.boolean :gamemaker, null: false, default: false
      t.boolean :spectator, null: false
      t.boolean :alive, null: false
      t.integer :target_id
      t.integer :assassin_id
      t.string  :kill_code
      t.datetime :time_of_death
      t.integer :points

      t.timestamps null: false
    end

    add_index :players, [:user_id, :game_id], unique: true
  end
end
