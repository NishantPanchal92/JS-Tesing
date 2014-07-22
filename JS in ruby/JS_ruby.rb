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
request.basic_auth("<USER_NAME>","<AUTOMATE_KEY>") 
response=http.request(request)
puts response.code
#puts response.body

#List of browsers
uri=URI.parse("http://api.browserstack.com/3/browsers")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("<USER_NAME>","<AUTOMATE_KEY>") 
response=http.request(request)
#puts response.code
puts response.body
#parsedJson= JSON.parse(response.body)

#To fetch the json data
# data=parsedJson["Windows"]["8.1"]
# data.each do |data|
# 	pp data["browser_version"]
# end

#Create a worker
uri=URI.parse("http://api.browserstack.com/3/worker")
request=Net::HTTP::Post.new(uri.request_uri)
request.initialize_http_header({"Content-Type" => "application/json", "Accept" => "application/json"})
request.basic_auth("<USER_NAME>","<AUTOMATE_KEY>") 
request.set_form_data("os" => "Windows", "os_version" => "7", "browser_version" => "8.0", "browser" => "ie", "url" => "http://google.com")
response=http.request(request)
#puts response.code
#puts response.body
jobId= JSON.parse(response.body)["id"]
puts "http://api.browserstack.com/3/worker/#{jobId}"

#Get job status
uri=URI.parse("http://api.browserstack.com/3/worker/#{jobId}")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("<USER_NAME>","<AUTOMATE_KEY>") 
response=http.request(request)
puts response.body

#Get all the workers
uri=URI.parse("http://api.browserstack.com/3/workers")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("<USER_NAME>","<AUTOMATE_KEY>") 
response=http.request(request)
puts response.body

#Get API status
uri=URI.parse("http://api.browserstack.com/3/status")
request=Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("<USER_NAME>","<AUTOMATE_KEY>") 
response=http.request(request)
puts response.body

#Delete worker 
uri=URI.parse("http://api.browserstack.com/3/worker/#{jobId}")
request=Net::HTTP::Delete.new(uri.request_uri)
request.basic_auth("<USER_NAME>","<AUTOMATE_KEY>") 
response=http.request(request)
puts response.body
