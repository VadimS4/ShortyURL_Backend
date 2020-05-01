class Link < ActiveRecord::Base

    validates :original_url, presence: true, on: :create
    validates :original_url, format: URI::regexp(%w[http https])
    before_create :generate_short_url

    #generate a short 6 character code for the short URL
    def generate_short_url
        random_string =['0'..'9', 'A'..'Z', 'a'..'z'].map{ |range| range.to_a }.flatten
        shorty = 6.times.map { random_string.sample }.join
        
        old_url = Link.where(short_url: shorty).last
        
        if old_url.present?
            self.generate_short_url
        else
            self.short_url = shorty
        end
    end

    #check to see if there is a duplicate in the database already.
    def find_duplicate
        Link.find_by(:result_url => self.result_url)
    end

    #if there is no duplicate, returns true for new_url, meaning it is a new link and not in the database
    def new_url?
        find_duplicate.nil?
    end

    #clean the url, so that every URL that is entered is the same. e.g https://google.com and https://www.google.com will
    #be the same instead of being entered into the database as 2 different URL's
    def clean
        self.original_url.strip!
        self.result_url = self.original_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
        self.result_url.slice!(-1) if self.result_url[-1] == "/"
        self.result_url = "http://#{self.result_url}"
    end
end
