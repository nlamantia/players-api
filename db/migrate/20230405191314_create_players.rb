class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players, id: false do |t|
      t.string :id, primary_key: true
      t.string :firstname
      t.string :lastname
      t.string :position
      t.integer :sport
      t.integer :age

      t.timestamps
    end
  end
end
