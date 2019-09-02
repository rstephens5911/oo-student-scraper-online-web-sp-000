require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    scraper = Nokogiri::HTML(open(index_url))
    students = []

    # iterate through the students

    scraper.css("div.student-card").each do |student|
      name = student.css("div h4.student-name").text
      location = student.css("div p.student-location").text
      profile_url = student.css("a").attribute("href").value
      student_info = {:name => name, :location => location, :profile_url => profile_url}
      students << student_info
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    scraper = Nokogiri::HTML(open(profile_url))
    student = {}

    icon_container = scraper.css(".social-icon-container a").collect { |icon|
      icon.attribute("href").value }
    icon_container.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?(".com")
        student[:blog] = link
      end
    end
    student[:profile_quote] = scraper.css(".profile-quote").text
    student[:bio] = scraper.css("div.description-holder p").text
    student
  end

end
