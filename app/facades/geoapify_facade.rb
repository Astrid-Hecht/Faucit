class GeoapifyFacade
  # Target field arrays for each API. As place APIs are addedin the future,
  # they will have their own hash element to allow target_field_filter to format uniformly
  TARGET_FIELDS = %i[name formatted categories place_id lon lat distance].freeze

  def self.get_nearby(query, categories = ['amenity'], page = 0, search_radius = 2500)
    coords = get_coords(query)
    raw_results = search(coords, categories, page, search_radius)
    target_field_filter(flattener(raw_results))
  end

  # PRIVATE METHODS
  #============================================================================

  def self.target_field_filter(raw_results)
    raw_results.map do |hit|
      hit.select { |key, _value| TARGET_FIELDS.include?(key) }
    end
  end

  def self.get_coords(query)
    raw_coords = GeoapifyService.get_coords(query)[:results].first
    { latitude: raw_coords[:lat], longitude: raw_coords[:lon] }
  end

  # Populates results. If less than 20, FE will need to query with a bigger radius if thay want more results
  def self.search(coords, categories, page, search_radius)
    raw_hits = []
    geoapify_response = GeoapifyService.get_nearby(coords[:latitude], coords[:longitude], categories, (page * 20), search_radius)
    raw_hits.concat(geoapify_response[:features]) if geoapify_response[:features].presence
  end

  # Flattens geoapify responses specifically
  def self.flattener(raw_hits)
    raw_hits.map do |raw_hit|
      raw_hit[:properties][:name] = 'No name' unless raw_hit[:properties][:name].present?
      raw_hit[:properties]
    end
  end

  # END Geoapify methods
  #  -------------------------------------------------------------------------

  private_class_method :get_coords,
                       :search,
                       :target_field_filter,
                       :flattener
end
