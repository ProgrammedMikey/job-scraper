require 'ferrum'

class IndeedScraper
  BASE_URL = "https://www.indeed.com/jobs?q=javascript&l=Orlando%2C+FL&fromage=14&radius=50&from=searchOnDesktopSerp"
  CHROME_PATH = "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
  # IMPORTANT: Replace this with a *current* and accurate User-Agent string
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"

  def self.call
    new.call
  end

  def call
    response = fetch_page
    if response
      response
    else
      puts "Failed to fetch data."
    end
  end

  private

  def fetch_page
    browser = Ferrum::Browser.new(
      timeout: 60, # Overall timeout
      browser_path: CHROME_PATH,
      headless: false,
      user_agent: USER_AGENT
    )

    browser.goto(BASE_URL)

    begin
      browser.evaluate("Object.defineProperty(navigator, 'webdriver', { get: () => undefined });")
    rescue Ferrum::JavaScriptError => e
      puts "Error setting navigator.webdriver: #{e.message}"
    end

    sleep(5) # Short initial delay

    job_main_loaded = false
    start_time = Time.now
    timeout = 55 # Timeout to wait for jobsearch-Main
    interval = 0.5

    while Time.now - start_time < timeout
      if browser.at_css('div#jobsearch-Main')
        job_main_loaded = true
        puts "Found the job listings container (jobsearch-Main)."
        break
      end
      sleep(interval)
    end

    if job_main_loaded
      puts "Job listings container loaded. Returning current page body."
      puts "Title: #{browser.title}"
      puts "Current URL: #{browser.current_url}"
      puts "Body Length: #{browser.body.length}"
      browser.body
    else
      puts "Timed out waiting for the job listings container (jobsearch-Main)."
      puts "--- Final Page Body ---"
      puts browser.body
      puts "--- End of Page Body ---"
      browser.body
    end
  rescue => e
    puts "Error: #{e.message}"
    nil
  ensure
    browser&.quit
  end
end