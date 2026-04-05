class AddSerebiiLinkToPokemon < ActiveRecord::Migration[8.1]
  def change
    add_column :pokemons, :serebii_url, :string
  end
end
