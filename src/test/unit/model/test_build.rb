require 'rubygems'
require 'bundler/setup'
require 'require_all'
require 'active_record'
require_all 'models/*.rb'
require "test/unit"
 
class TestBuild < Test::Unit::TestCase
 
  # todo: should handle empty folder too
  def test_parse_jenkins_id
    # should parse folder, job, and build number correctly
    id = '"tag:hudson.dev.java.net,2018:kai/Deploy KAI Web - Staging:651'
    expected_result = {
      folder: 'kai',
      job: 'Deploy KAI Web - Staging',
      number: 651
    }
    assert_equal(expected_result, Build.parse_jenkins_id(id))


    id = '"tag:hudson.dev.java.net,2018:Deploy KAI Web - Staging:666'
    expected_result = {
      folder: '',
      job: 'Deploy KAI Web - Staging',
      number: 666
    }
    assert_equal(expected_result, Build.parse_jenkins_id(id))
  end
end
