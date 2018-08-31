require 'json'
require 'open-uri'
require 'nokogiri'

url       = 'http://www.wegottickets.com/searchresults/all'
html_file = open(url).read
html_doc  = Nokogiri::HTML(html_file)

html_doc.search('.event_link').each do |event_link|
  next_url       = event_link.attribute('href').value
  next_html_file = open(next_url).read
  next_html_doc  = Nokogiri::HTML(next_html_file)

  info = {}

  venue_details = next_html_doc.search('.venue-details')
  info[:city]   = venue_details.search('h2').text.split(":")[0]
  info[:date]   = venue_details.search('h4').text

  event_information = next_html_doc.search('.event-information')
  info[:venue]      = event_information.search('h1').text

  booking_fee = next_html_doc.search('.searchResultsPrice')
  
  p info
  filepath = 'events.json'
  File.open(filepath, 'a') do |file|
  file.write(JSON.generate(info))
end

end


