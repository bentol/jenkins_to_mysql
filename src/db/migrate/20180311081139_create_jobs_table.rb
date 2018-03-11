class CreateJobsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :folder
      t.string :display_name
      t.string :url
      t.string :health_score
      t.string :health_description

      t.integer :failed_streak

      t.integer :last_build_number
      t.timestamp :last_build_timestamp
      t.string :last_build_result

      t.index [:name]
      t.index [:name, :folder]
      t.index [:health_score]
      t.index [:failed_streak]
    end

  end
end
