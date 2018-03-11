require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'require_all'
require 'json'
require 'pp'
require 'date'
require 'nokogiri'
require 'pry'
require 'faraday'
require_all 'models/*.rb'

db_config = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

jobs = {}
Job.all.each do |job|
  jobs["#{job.folder}-#{job.name}"] = job
end

def get_data
  doc = File.open("../test_data/rss_build.xhtml") { |f| Nokogiri::XML(f) }
  return doc.remove_namespaces!
end

def fetch_build_details(url)
  api_url = url + '/api/json'
  response = Faraday.get do |req|
    req.url api_url
    req.headers['Authorization'] = ENV['JENKINS_AUTH']
  end

  return JSON.parse(response.body)
end

def parse_xml_entry(doc)
  title = entry.xpath('title').text
end

def process_entry(entry, jobs)
  build_info = Build.parse_jenkins_id(entry.xpath('id').text)
  build_url = entry.xpath('link/@href').text
  job = build_info[:job]
  folder = build_info[:folder]
  build_number = build_info[:number]

  if job =~ /cron/
    pp build_info
    return
  end

  key = "#{folder}-#{job}"
  job = jobs[key]
  if job.nil? 
    puts "key not found #{key}"
    raise "key not found #{key}"
  end

  is_build_exists = Build.where(job_id: job.id, number: build_number).exists?
  if is_build_exists
    return
  end

  build_details = fetch_build_details(build_url)
  Build.create(
    job_id: job.id,
    number: build_number,
    url: build_url,
    timestamp: DateTime.strptime(build_details['timestamp'].to_s,'%Q') ,
    result: build_details['result'],
    duration: build_details['duration']

  )
end

get_data().xpath('feed/entry').each do |entry|
  id = entry.xpath('id').text
  puts "Processing: #{id}"
  begin
    process_entry(entry, jobs)
    puts "+Done: #{id}"
  rescue Exception => e
    pp e
    exit
    puts "-Failed: #{id}"
  end
end
