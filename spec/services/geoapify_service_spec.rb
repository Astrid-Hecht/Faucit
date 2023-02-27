require 'rails_helper'

describe GeoapifyService, :vcr do
  it '.get_coords' do 
    query = "1303 Pearl St, Boulder, CO 80302"

    coords = GeoapifyService.get_coords(query)[:results]

    expect(coords).to be_a(Hash)
    expect(coords[:lon]).to eq(-105.27854034693877)
    expect(coords[:lon]).to eq(40.01828830612245)
  end

  it '.get_nearby' do
    places = GeoapifyService.get_nearby(city_info)[:features]

    expect(places).to be_an Array
    expect(places.count).to eq(20)

    hit = places[0]

    expect(hit).to be_a(Hash)
    expect(hit.keys).to eq(%i[type properties geometry])
    prop = hit[:properties]
    expect(prop[:city]).to be_a(String)
    expect(prop[:country]).to eq("France")
    expect(prop[:name]).to be_a(String)
    expect(prop[:lon]).to be_a(Float)
    expect(prop[:lat]).to be_a(Float)
    expect(prop[:address_line1]).to be_a(String)
    expect(prop[:address_line2]).to be_a(String)
    expect(prop[:categories]).to be_a(Array)
    expect(prop[:categories][0]).to be_a(String)
    expect(prop[:place_id]).to be_a(String)
  end
end
