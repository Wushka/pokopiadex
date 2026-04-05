
require 'net/http'
require 'uri'
require 'nokogiri'

Pokemon.all.each do |pokemon|
pp pokemon.id
    url = pokemon.source_url
    uri = URI.parse url
    resp = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML.parse resp.body
    
    fields = doc.search("table.tab, allign.center")[2].xpath('./tr')[2].xpath('./td')
    speciality = fields[0]
    ideal_habitat = fields[1]
    favorites = fields[2]

    speciality.search("tr").each do |spec|
        pokemon_speciality = Speciality.find_or_create_by(name: spec.content)
        pokemon.specialities << pokemon_speciality unless pokemon.specialities.include? pokemon_speciality
    end

    pokemon.update(habitat: Habitat.find_or_create_by(name: ideal_habitat.content))

    favorites.search("a").each do |fav|
        pokemon_fav = Favorite.find_or_create_by(name: fav.content)
        pokemon.favorites << pokemon_fav unless pokemon.favorites.include? pokemon_fav
    end
end