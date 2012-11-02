class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.integer :project_id

      t.datetime :run_at
      t.datetime :stop_at

      t.integer :status, :default => 0

      t.timestamps
    end
  end
end
