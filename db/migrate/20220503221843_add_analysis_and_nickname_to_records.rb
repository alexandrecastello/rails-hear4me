class AddAnalysisAndNicknameToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :nickname, :string
  end
end
