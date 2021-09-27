class CreateStreamers < ActiveRecord::Migration[6.1]
  def change
    create_table :streamers do |t|
      t.string :username
      t.string :userid
      t.integer :opes_number
      t.string :videos_liste

      t.timestamps
    end
  end
end
