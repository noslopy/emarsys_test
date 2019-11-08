# frozen_string_literal: true

# Create Issues table
class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string    :name
      t.text      :description
      t.integer   :turnaround
      t.datetime  :submit_date

      t.timestamps
    end
  end
end
