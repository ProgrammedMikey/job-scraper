# app/services/indeed_scraper.rb
require 'open-uri'
require 'nokogiri'

class IndeedScraper
  BASE_URL = "https://www.indeed.com/jobs?q=javascript&l=Orlando%2C+FL&fromage=14&radius=50&from=searchOnDesktopSerp"

  def self.call
    new.call
  end

  def call
    document = fetch_page
    parse_jobs(document)
  end

  private

  def fetch_page
    Nokogiri::HTML(URI.open(BASE_URL))
  end

  def parse_jobs(doc)
    doc.css('.jobsearch-SerpJobCard, .job_seen_beacon').map do |job_card|
      {
        title:        job_card.at_css('h2.jobTitle span')&.text&.strip,
        company_name: job_card.at_css('.companyName')&.text&.strip,
        location:     job_card.at_css('.companyLocation')&.text&.strip,
        job_link:     full_job_link(job_card.at_css('a')&.[]('href'))
      }
    end.compact
  end

  def full_job_link(path)
    return nil unless path
    URI.join("https://www.indeed.com", path).to_s
  end
end
