class AddColumnAllVideosList < ActiveRecord::Migration[6.1]
  def change
  	add_column :streamers, :all_videos_list, :text
  end
end
