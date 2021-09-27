class ChangeFieldNameVideosListe < ActiveRecord::Migration[6.1]
  def change
	rename_column :streamers, :videos_liste, :videos_list
  end
end
