class AddAudioUrlToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :audio_url, :string
  end
end
