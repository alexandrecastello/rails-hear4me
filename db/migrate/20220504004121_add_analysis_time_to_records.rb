class AddAnalysisTimeToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :analysis_time, :float
  end
end
