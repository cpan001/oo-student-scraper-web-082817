require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)
    students = index_page.css(".student-card")
    students.collect do |student|
      hash = {}
      hash[:name] = student.css("h4.student-name").text
      hash[:location] = student.css("p.student-location").text
      hash[:profile_url] = student.css("a").attribute("href").value
      hash
    end
    # binding.pry
  end

  def self.scan(string)
    url = string.scan(/(\w*)\.com/)[0]
    if url.class == String
      url
    elsif url.class == Array
      url[0]
    end
  end

  def self.link_type(string)
    case string
    when "twitter"
      "twitter".to_sym
    when "github"
      "github".to_sym
    when "linkedin"
      "linkedin".to_sym
    else
      "blog".to_sym
    end
  end


  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile_page = Nokogiri::HTML(html)
    prof_hash = {}
    links = profile_page.css(".social-icon-container a")
    links.each do |link|
      link_url = link.attribute("href").value
      blog_type = Scraper.scan(link_url)
      link_key = Scraper.link_type(blog_type)
      prof_hash[link_key] = link_url
    end
    prof_hash[:profile_quote] = profile_page.css(".profile-quote").text
    prof_hash[:bio] = profile_page.css(".description-holder p").text
    prof_hash
  end
end
