class Link < ActiveRecord::Base

    validates :original_url, presence: true, on: :create
    validates :original_url, format: URI::regexp(%w[http https])
    before_create :generate_short_url
    validates :short_url, uniqueness: true

    #generate a short 6 character code for the short URL
    def generate_short_url
        random_string =['0'..'9', 'A'..'Z', 'a'..'z'].map{ |range| range.to_a }.flatten
        shorty = 6.times.map { random_string.sample }.join
        
        #This method checks to see if there is a short_url in the database already
        same_short_url = Link.find_by(:short_url => shorty)
        
        # If there is a short_url in the database like the one randomly generated, it will generate another short_url
        if same_short_url.present?
            self.generate_short_url
        else
            # If not in the database, it sets the new short_url
            self.short_url = shorty
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
