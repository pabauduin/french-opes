class RemoveFieldUserid < ActiveRecord::Migration[6.1]
  def change
    remove_column :streamers, :userid
  end
end
