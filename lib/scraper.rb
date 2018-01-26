require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    school = []
    cards = doc.css("div.roster-cards-container")
    cards.each do |card|
     card.css('.student-card a').each do |student|
       name = student.css('.student-name').text
       location = student.css('.student-location').text
       profile = "#{student.attr('href')}"
       school << {name: name, location: location, profile_url: profile}
     end
   end
   school
 end


   def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    profile = Nokogiri::HTML(html)
    student = {}
    cats = profile.css(".social-icon-container a").each do |link|
      link_attribute = link.attribute("href").value
      if link_attribute.include?('twitter')
        student[:twitter] = link_attribute
      elsif link_attribute.include?('linkedin')
        student[:linkedin] = link_attribute
      elsif link_attribute.include?('github')
          student[:github] = link_attribute
      else student[:blog] = link_attribute
      end
    end
    student[:profile_quote] = profile.css('.profile-quote').text
    student[:bio] = profile.css('.bio-content .description-holder p').text
    student
  end
end
