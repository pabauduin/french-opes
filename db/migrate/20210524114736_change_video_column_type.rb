class ChangeVideoColumnType < ActiveRecord::Migration[6.1]
  def change
  	change_column :streamers, :videos_list, :text
  end
end
