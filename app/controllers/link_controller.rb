class LinkController < ApplicationController

    skip_before_action :verify_authenticity_token
    
    def show
        @link = Link.find_by(:short_url => params[:short_url])
        redirect_to @link.original_url
    end

    def create
        @link = Link.create(:original_url => params[:original_url])
        render :json => @link.to_json(:only => [:original_url, :short_url])
    end

end