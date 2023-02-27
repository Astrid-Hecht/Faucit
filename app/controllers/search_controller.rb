class SearchController < ApplicationController

  def index
    if params_unisex?
      conditions = {accessible: params[:ada], unisex: params[:unisex]}
      @results = RefugeFacade.get_nearby(params[:address], conditions)
    else
      @results = GeoapifyFacade.get_nearby(params[:address], categories)
    end
  end

  private

  def categories
    categories = ["amenity"]
    categories <<['amenity.toilet'] if params[:foutains].to_i.zero?
    categories << "wheelchair" if params_ada?
    categories
  end

  def params_unisex?
    !params[:unisex].to_i.zero?
  end

  def params_ada?
    !params[:ada].to_i.zero?
  end
end