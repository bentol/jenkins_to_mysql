require 'pry'

class Build < ActiveRecord::Base

  def self.parse_jenkins_id(str_id)
    groups = str_id.split(':')
    number = groups[-1]
    folder = groups[-2].split('/')[0]
    job = groups[-2].split('/')[-1]
    
    folder = '' if folder == job

    return {
      number: number.to_i,
      folder: folder,
      job: job
    }
  end

end
