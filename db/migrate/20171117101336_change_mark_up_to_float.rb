class ChangeMarkUpToFloat < ActiveRecord::Migration[5.1]
  def change
     change_column :jogging_logs, :duration, :float
  end
end
