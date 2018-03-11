class CreateBuildsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :builds do |t|
      t.belongs_to :job
      t.integer :number
      t.string :url
      t.timestamp :timestamp
      t.string :result
      t.integer :duration

      t.index([:job_id, :number], unique: true)
      t.index [:number]
      t.index [:result]
      t.index [:timestamp]
    end

  end
end
