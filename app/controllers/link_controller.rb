class LinkController < ApplicationController

    before_action :find_url, only: [:show, :shorten]
    skip_before_action :verify_authenticity_token

    def index
        @link = Link.all
        render :json => @link.to_json(:only => [:short_url, :result_url])
    end
    
    def show
        @link = Link.find_by(:short_url => params[:short_url])
        redirect_to @link.result_url
    end

    def create
        # @link = Link.create(:original_url => params[:original_url])
        @link = Link.new(url_params)
        @link.clean
        if @link.new_url?
            if @link.save
                render json: { shorten: shorten(@link.short_url), all: Link.all }
            else
                render json: { message: "This is an invalid link." }
            end
        else
            render json: { shorten: shorten(@link.find_duplicate.short_url), all: Link.all, message: "A short link for this URL already exists!" }
        end
    end

    def delete
        @link = Link.find_by(:short_url => params[:short_url])
        @link.destroy
        render json: { link: @link, all: Link.all }
    end

    def shorten(short_url)
        @link = Link.find_by(:short_url => short_url)
        host = request.host_with_port
        @original_url = @link.result_url
        @short_url = host + '/' + @link.short_url
    end

    private

    def find_url
        @link = Link.find_by(:short_url => params[:short_url])
    end

    def url_params
        params.require(:link).permit(:original_url)
    end
end