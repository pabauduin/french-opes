class AddColumnVideosNumber < ActiveRecord::Migration[6.1]
  def change
  	add_column :streamers, :videos_number, :integer
  end
end
