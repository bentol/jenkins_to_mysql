require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'require_all'
require 'json'
require 'pp'
require 'date'
require_all 'models/*.rb'

db_config = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)


def get_data
  f = File.read('../test_data/jenkins.json')
  data = JSON.parse(f)
  return data
end

data = get_data()
data['jobs'].each do |folder|
  next if folder['jobs'].nil?

  pp folder['name']
  folder['jobs'].each do |j|

    if j.has_key?('healthReport') and j['healthReport'].length > 0
      health_score = j['healthReport'][0]['score']
      health_description = j['healthReport'][0]['description']
    end

    job = Job.where(name: j['name'], folder: folder['name']).first_or_initialize
    job.display_name = j['displayName']
    job.url = j['url']
    job.health_score = health_score
    job.health_description = health_description

    if !j['lastBuild'].nil? && j['lastBuild']['building'] == false
      job.last_build_number = j['lastBuild']['number']
      job.last_build_timestamp = DateTime.strptime(j['lastBuild']['timestamp'].to_s,'%Q') 
      job.last_build_result = j['lastBuild']['result']
    end

    job.save!
  end
end
