require 'rails_helper'

RSpec.describe GeoapifyFacade, :vcr do
  let(:query) { "1303 Pearl St, Boulder, CO 80302" }

  describe '.get_nearby with category' do
    it 'returns places from location' do
      places = GeoapifyFacade.get_nearby(query, ['amenity.toilet'])

      expect(places).to be_an Array

      hit = places[0]

      expect(hit).to be_a(Hash)
      expect(hit.keys).to match_array(%i[name lon lat formatted categories distance place_id])
      expect(hit[:name]).to be_a(String)
      expect(hit[:formatted]).to be_a(String)
      expect(hit[:categories]).to be_a(Array)
      expect(hit[:categories][0]).to be_a(String)
      expect(hit[:lat]).to be_a(Float)
      expect(hit[:lon]).to be_a(Float)
      expect(hit[:distance]).to be_a(Integer)
    end
  end
end
