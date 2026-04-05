class PokemonsController < ApplicationController
  before_action :set_pokemon, only: %i[ show edit update destroy ]

  helper_method :add_value_to_filter, :remove_value_from_filter

  # GET /pokemons or /pokemons.json
  def index
    @decoded = params[:filter].nil? ? {"spec" => [], "fav" => []} : JSON.parse(Base64.decode64(params[:filter]))
    @fav = @decoded["fav"] || []
    @spec =  @decoded["spec"] || []
    @hab =  @decoded["hab"]

    @pokemons = Pokemon.all.includes(:favorites, :specialities, :habitat)
    @pokemons = @pokemons.with_favorites(@fav) if @fav.any?
    @pokemons = @pokemons.with_specialities(@spec) if @spec.any?
    @pokemons = @pokemons.with_habitat(@hab) if @hab
  end

  # GET /pokemons/1 or /pokemons/1.json
  def show
  end

  # GET /pokemons/new
  def new
    @pokemon = Pokemon.new
  end

  # GET /pokemons/1/edit
  def edit
  end

  # POST /pokemons or /pokemons.json
  def create
    @pokemon = Pokemon.new(pokemon_params)

    respond_to do |format|
      if @pokemon.save
        format.html { redirect_to @pokemon, notice: "Pokemon was successfully created." }
        format.json { render :show, status: :created, location: @pokemon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pokemon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pokemons/1 or /pokemons/1.json
  def update
    respond_to do |format|
      if @pokemon.update(pokemon_params)
        format.html { redirect_to @pokemon, notice: "Pokemon was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @pokemon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pokemon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pokemons/1 or /pokemons/1.json
  def destroy
    @pokemon.destroy!

    respond_to do |format|
      format.html { redirect_to pokemons_path, notice: "Pokemon was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def add_value_to_filter(filter, key, value)
    ret_filter = filter.deep_dup
    if ret_filter[key].is_a?(Array)
      ret_filter[key] = ret_filter[key] |= [value]
    else
      ret_filter[key] = value
    end
    Base64.encode64(ret_filter.to_json)
  end
    
  def remove_value_from_filter(filter, key, value)
    ret_filter = filter.deep_dup
    if ret_filter[key].is_a?(Array)
      ret_filter[key] = ret_filter[key] - [value]
    else
      ret_filter[key] = nil
    end
    Base64.encode64(ret_filter.to_json)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pokemon
      @pokemon = Pokemon.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pokemon_params
      params.fetch(:pokemon, {})
    end
end
