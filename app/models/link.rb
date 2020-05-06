class Link < ActiveRecord::Base

    validates :original_url, presence: true, on: :create
    validates :original_url, format: URI::regexp(%w[http https])
    before_create :generate_short_url
    validates :short_url, uniqueness: true

    #generate a short 6 character code for the short URL
    def generate_short_url
        random_string =['0'..'9', 'A'..'Z', 'a'..'z'].map{ |range| range.to_a }.flatten
        shorty = 6.times.map { random_string.sample }.join

        #This unique_shorty method generates a random short_url until it is not found in the database
        #this method is just in case the uniqueness validation does not work.
        until Link.find_by(short_url: shorty).nil?
            unique_shorty = shorty
        end
        
        old_url = Link.where(short_url: unique_shorty).last
        
        if old_url.present?
            self.generate_short_url
        else
            self.short_url = unique_shorty
        end
    end

    #check to see if there is a duplicate in the database already.
    def find_duplicate
        Link.find_by(:original_url => self.original_url)
    end

    #if there is no duplicate, returns true for new_url, meaning it is a new link and not in the database
    def new_url?
        find_duplicate.nil?
    end
end
