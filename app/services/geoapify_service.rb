class GeoapifyService
  def self.get_nearby(lat, long, categories = ["amenity"], offset = 0, radius = 2500)
    response = conn.get("/v2/places") do |f|
      f.params['categories'] = categories.join(',')
      f.params['bias'] = "proximity:#{long},#{lat}"
      f.params['filter'] = "circle:#{long},#{lat},#{radius}"
      f.params['offset'] = offset
      f.params['limit'] = '20'
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_coords(query)
    response = conn.get("/v1/geocode/search") do |f|
      f.params['text'] = query
      f.params['format'] = "json"
      f.params['limit'] = '1'
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  # PRIVATE METHODS
  #===============================================================

  def self.conn
    Faraday.new('https://api.geoapify.com') do |f|
      f.params['apiKey'] = ENV['places_api_key']
    end
  end

  private_class_method :conn
end
