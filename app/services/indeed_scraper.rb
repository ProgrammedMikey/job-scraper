class IndeedScraper
    BASE_URL = "https://www.indeed.com/jobs?q=javascript&l=Orlando%2C+FL&fromage=14&radius=50&from=searchOnDesktopSerp"
  
    def self.call
      new.call
    end
  
    def call
      response = fetch_page
      if response
        response # Return raw response if successful
      else
        puts "Failed to fetch data."
      end
    end
  
    private
  
    def fetch_page
      response = HTTParty.get(BASE_URL, headers: {
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept-Language" => "en-US,en;q=0.9",
        "Accept" => "application/json, text/plain, */*",
        "Referer" => "https://www.google.com/",
        "Accept-Encoding" => "gzip, deflate, br",
        "Connection" => "keep-alive",
        "Upgrade-Insecure-Requests" => "1"
      })
    
      puts "HTTP Status Code: #{response.code}" # Log the HTTP status code
      if response.code == 200
        puts "Response body length: #{response.body.length}" # Log the length of the response body
        return response.body # Return raw HTML
      else
        puts "Error: Unable to fetch data. HTTP Status Code: #{response.code}"
        return nil
      end
    end
  end
  