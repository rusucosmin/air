class CreateJoggingLogs < ActiveRecord::Migration[5.1]
  def change
    drop_table :jogging_logs
    create_table :jogging_logs do |t|
      t.date :date
      t.integer :duration
      t.float :distance
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
