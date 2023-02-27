class SearchController < ApplicationController

  def index
    if params_unisex? || params_ada?
      conditions = {accessible: params[:ada], unisex: params[:unisex]} 
      @results = RefugeFacade.get_nearby(params[:address], conditions)
    else
      @results = GeoapifyFacade.get_nearby(params[:address], categories)
    end
  end

  private

  def categories
    if params[:foutains].presence
      ["amenity"]
    else
      ['amenity.toilet']
    end
  end

  def params_unisex?
    params[:unisex].presence
  end

  def params_ada?
    params[:ada].presence
  end
end