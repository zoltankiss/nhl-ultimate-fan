# frozen_string_literal: true

class CreateJobData < ActiveRecord::Migration[7.0]
  def change
    create_table :job_data do |t|
      t.string :job_name
      t.string :label

      t.timestamps
    end
  end
end
