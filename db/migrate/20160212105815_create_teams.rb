class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :game_id, null: false, index: true
      t.string :name

      t.timestamps null: false
    end

    add_column :players, :team_id, :integer
    add_index :teams, [:game_id, :name], unique: true
  end
end
