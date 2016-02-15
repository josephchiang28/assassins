class RefactorAssignmentSchema < ActiveRecord::Migration
  def change
    add_column :assignments, :status, :string, null: false, default: 'inactive'
    add_column :assignments, :time_activated, :datetime
    rename_column :assignments, :time_terminated, :time_deactivated
    remove_column :assignments, :reverse_killed, :boolean
  end
end
