class RefugeFacade
  TARGET_FIELDS = %i[name formatted categories id lon lat distance directions comment ratings].freeze

  def self.get_nearby(query, conditions, page = 0)
    coords = get_coords(query)
    raw_results = search(coords, conditions, page)
    target_field_filter(digest(raw_results))
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

  def self.search(coords, conditions, page)
    RefugeService.get_nearby(coords[:latitude], coords[:longitude], conditions, page)
  end

  def self.digest(raw_hits)
    raw_hits.map do |raw_hit|
      raw_hit[:name] = 'No name' unless raw_hit[:name].present?
      raw_hit[:formatted] = "#{raw_hit[:street]}, #{raw_hit[:city]}, #{raw_hit[:state]}"
      raw_hit[:categories] = ["unisex.#{raw_hit[:unisex]}", "accessible.#{raw_hit[:accessible]}"]
      raw_hit[:distance] = (raw_hit[:distance] * 1609.34).round(3)
      raw_hit[:ratings] = [raw_hit[:upvote], raw_hit[:downvote]]
      raw_hit[:lat] = raw_hit[:latitude]
      raw_hit[:lon] = raw_hit[:longitude]
      raw_hit
    end
  end

  private_class_method :get_coords,
                       :search,
                       :target_field_filter,
                       :digest
end
