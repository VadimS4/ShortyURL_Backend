class Link < ActiveRecord::Base

    validates_presence_of :original_url
    validates_uniqueness_of :short_url

    before_create :generate_short_url

    def generate_short_url
        random_string =['0'..'9', 'A'..'Z', 'a'..'z'].map{ |range| range.to_a }.flatten
        self.short_url = 6.times.map { random_string.sample }.join if self.short_url.nil? || self.short_url.empty?
        true
    end
end
