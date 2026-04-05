class Pokemon < ApplicationRecord
  has_and_belongs_to_many :specialities
  has_and_belongs_to_many :favorites

  belongs_to :habitat

  scope :with_favorites, -> (favorites) {
    favs = Favorite.where(name: favorites)
    pkmn_ids = favs.first.pokemon_ids
    favs[1..].each do |fav|
      pkmn_ids = pkmn_ids & fav.pokemon_ids
    end
    Pokemon.where(id: pkmn_ids)
  }
  
  scope :with_specialities, -> (specialities) {
    specs = Speciality.where(name: specialities)
    pkmn_ids = specs.first.pokemon_ids
    specs[1..].each do |spec|
      pkmn_ids = pkmn_ids & spec.pokemon_ids
    end
    Pokemon.where(id: pkmn_ids)
  }

  scope :with_habitat, -> (habitat) {
    where(habitat: Habitat.find_by(name: habitat))
  }

  SOURCE = "https://www.serebii.net/"

  def full_picture_url
     SOURCE + picture_url
  end

  def source_url
    SOURCE + serebii_url
  end
end
