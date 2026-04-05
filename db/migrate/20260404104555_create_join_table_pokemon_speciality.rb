class CreateJoinTablePokemonSpeciality < ActiveRecord::Migration[8.1]
  def change
    create_join_table :pokemons, :specialities
  end
end
