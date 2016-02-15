class Assignment < ActiveRecord::Base
  belongs_to :game

  STATUS_INACTIVE = 'inactive'   # Assignment generated but not confirmed and activated
  STATUS_ACTIVE = 'active'       # Assignment confirmed and activated
  STATUS_FAILED = 'failed'       # Got killed before completing assignment
  STATUS_STOLEN = 'stolen'       # Target got reverse killed
  STATUS_COMPLETED = 'completed' # Successful completion of assignment
  STATUS_BACKFIRED = 'backfired' # Got reverse killed
end
