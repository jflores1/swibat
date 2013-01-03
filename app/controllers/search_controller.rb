class SearchController < ApplicationController
  def index
  	@query = params[:query]
    @results = PgSearch.multisearch(params[:query]).paginate(:page => params[:page], :per_page => 10)
  end
end
