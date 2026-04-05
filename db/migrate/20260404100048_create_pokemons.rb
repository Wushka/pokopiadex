class CreatePokemons < ActiveRecord::Migration[8.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.integer :dex_nr
      t.string :picture_url

      t.timestamps
    end
  end
end
