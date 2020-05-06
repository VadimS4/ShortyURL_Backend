class Link < ActiveRecord::Base

    validates :original_url, presence: true, on: :create
    validates :original_url, format: URI::regexp(%w[http https])
    before_create :generate_short_url
    validates :short_url, uniqueness: true

    #generate a short 6 character code for the short URL
    def generate_short_url
        random_string =['0'..'9', 'A'..'Z', 'a'..'z'].map{ |range| range.to_a }.flatten
        self.short_url = 6.times.map { random_string.sample }.join
        
        self.short_url = 6.times.map { random_string.sample }.join until Link.find_by(:short_url => self.short_url).nil?
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
