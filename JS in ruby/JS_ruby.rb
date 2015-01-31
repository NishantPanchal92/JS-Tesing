#JS tesing via ruby
require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'pp'

#General authentication
uri= URI.parse("http://api.browserstack.com/3")
#response=Net::HTTP.get_response(uri)
#Net::HTTP.get_print(uri)
http = Net::HTTP.new(uri.host, uri.port)

request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("USERNAME","AUTOMATE_KEY") 
response=http.request(request)
puts response.code
#puts response.body

#List of browsers
uri=URI.parse("http://api.browserstack.com/3/browsers")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("USERNAME","AUTOMATE_KEY") 
response=http.request(request)
puts response.body

## To fetch particular data from the JSON retrieved ##
parsedJson= JSON.parse(response.body)
data=parsedJson["Windows"]["8.1"]
data.each do |data|
  pp data["browser_version"]
end

#Create a worker
uri=URI.parse("http://api.browserstack.com/3/worker")
request=Net::HTTP::Post.new(uri.request_uri)
request.initialize_http_header({"Content-Type" => "application/json", "Accept" => "application/json"})
request.basic_auth("USERNAME","AUTOMATE_KEY") 

## Capabilities for running tests on desktop browsers and mobile devices  ##
request.set_form_data("os" => "OS X", "os_version" => "Mavericks", "browser_version" => "7", "browser" => "safari", "url" => "http://localhost", "build" => "Local JS", "browserstack.local" => "true")

## Capabilities for running tests on iOS simulators ##
# request.set_form_data("build" => "ios test", "real_mobile" => 'false', "device" => "iPhone 5S", "os" => "ios", "os_version" => "7.0", "browser_version" => "null", "browser" => "Mobile Safari", "url" => "http://localhost")

response=http.request(request)
jobId= JSON.parse(response.body)["id"]
puts "http://api.browserstack.com/3/worker/#{jobId}"

## Get job status. The script will continue only after it receives the "running" status ##
puts "Job Status"
uri=URI.parse("http://api.browserstack.com/3/worker/#{jobId}")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("USERNAME","AUTOMATE_KEY")
response=http.request(request)
status = JSON.parse(response.body)["status"]
puts status
while status!="running"
response = http.request(request)
status = JSON.parse(response.body)["status"]
puts status
end

## Capture Screenshot ##
puts "Screenshot status"
uri=URI.parse("http://api.browserstack.com/3/worker/#{jobId}/screenshot.json")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("USERNAME","AUTOMATE_KEY")
response=http.request(request)
puts response.body
puts "screenshot captured"

## Get all active workers ##
uri=URI.parse("http://api.browserstack.com/3/workers")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("USERNAME","AUTOMATE_KEY") 
response=http.request(request)
puts response.body

## Get API status ##
uri=URI.parse("http://api.browserstack.com/3/status")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("USERNAME","AUTOMATE_KEY") 
response=http.request(request)
puts response.body

## Delete worker ##
uri=URI.parse("http://api.browserstack.com/3/worker/#{jobId}")
request=Net::HTTP::Delete.new(uri.request_uri)
request.basic_auth("USERNAME","AUTOMATE_KEY") 
response=http.request(request)
puts response.body
