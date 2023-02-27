class RefugeService
  def self.get_nearby(lat, long, conditions, offset = 0)
    response = conn.get("/api/v1/restrooms/by_location") do |f|
      f.params['ada'] = conditions[:accessible]
      f.params['unisex'] = conditions[:unisex]
      f.params['lat'] = lat
      f.params['lng'] = long
      f.params['offset'] = offset
      f.params['per_page'] = '20'
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  # PRIVATE METHODS
  #===============================================================

  def self.conn
    Faraday.new('https://www.refugerestrooms.org')
  end

  private_class_method :conn
end
