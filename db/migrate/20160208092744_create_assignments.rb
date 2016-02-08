class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :game_id, null: false, index: true
      t.integer :killer_id, null: false
      t.integer :target_id, null: false
      t.datetime :time_terminated
      t.boolean :reverse_killed, null: false

      t.timestamps null: false
    end
  end
end
