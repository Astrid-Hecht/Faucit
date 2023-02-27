require 'rails_helper'

describe RefugeService, :vcr do
  it '.get_nearby' do
    lat = 48.8588897
    long = 2.3200410217200766
    conditions = { accessible: false, unisex: true }
 
    places = RefugeService.get_nearby(lat, long, conditions)

    expect(places).to be_an Array
    expect(places.count).to eq(20)

    hit = places[0]

    expect(hit).to be_a(Hash)
    expect(hit.keys).to match_array(%i[id
                                       name
                                       street
                                       city
                                       state
                                       accessible
                                       unisex
                                       directions
                                       comment
                                       latitude
                                       longitude
                                       created_at
                                       updated_at
                                       downvote
                                       upvote
                                       country
                                       changing_table
                                       edit_id
                                       approved
                                       distance
                                       bearing])
    expect(hit[:name]).to be_a(String)
    expect(hit[:street]).to be_a(String)
    expect(hit[:state]).to be_a(String)
    expect(hit[:directions]).to be_a(String)
    expect(hit[:comment]).to be_a(String)
    expect(hit[:latitude]).to be_a(Float)
    expect(hit[:longitude]).to be_a(Float)
    expect(hit[:downvote]).to be_a(Integer)
    expect(hit[:upvote]).to be_a(Integer)
    expect(hit[:distance]).to be_a(Float)
  end
end
