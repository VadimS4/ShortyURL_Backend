class Link < ActiveRecord::Base

    validates :original_url, presence: true, on: :create
    before_create :generate_short_url

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

    def find_duplicate
        Link.find_by(:result_url => self.result_url)
    end

    def new_url?
        find_duplicate.nil?
    end

    def clean
        self.original_url.strip!
        self.result_url = self.original_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
        self.result_url.slice!(-1) if self.result_url[-1] == "/"
        self.result_url = "http://#{self.result_url}"
    end
end
