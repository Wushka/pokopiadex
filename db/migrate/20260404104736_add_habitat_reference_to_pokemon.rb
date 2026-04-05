class AddHabitatReferenceToPokemon < ActiveRecord::Migration[8.1]
  def change
    add_reference :pokemons, :habitat, foreign_key: true
  end
end
