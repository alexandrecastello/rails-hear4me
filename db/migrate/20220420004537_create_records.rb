class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.string :filename
      t.string :analysis
      t.string :transcription
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
