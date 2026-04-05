
require 'net/http'
require 'uri'
require 'nokogiri'

url = 'https://www.serebii.net/pokemonpokopia/availablepokemon.shtml'
uri = URI.parse url
resp = Net::HTTP.get_response(uri)
doc = Nokogiri::HTML.parse resp.body
doc.search("table.tab, allign.center")[1].xpath('./tr')[1..].each_with_index do |pokemon, index|
    nr = pokemon.children[1].content[-3..].to_i
    png_url = pokemon.children[3].child.child["src"]
    src = pokemon.children[5].child["href"]
    name = pokemon.children[5].child.child.child.content
    p = Pokemon.find_or_create_by(dex_nr: nr, name:)
    
    p.picture_url = png_url
    p.serebii_url = src
    p.save
end