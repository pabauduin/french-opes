class AddColumnProfilePic < ActiveRecord::Migration[6.1]
  def change
  	add_column :streamers, :profile_pic, :string
  end
end
