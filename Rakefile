require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "active_record"
require "mysql2"
require "yaml"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  task :create do
    client = Mysql2::Client.new(:host => 'localhost', :username=>"root", :password=> "")
    client.query("CREATE DATABASE gakky_bot")
  end

  task :drop do
    client = Mysql2::Client.new(:host => 'localhost', :username=>"root", :password=> "")
    client.query("DROP DATABASE gakky_bot")
  end

  task :migrate do
    ActiveRecord::Base.establish_connection(YAML.load_file(File.expand_path("../lib/gakky_bot/config/database.yml", __FILE__)))

    ActiveRecord::Migration.class_eval do

      create_table :tokens do |t|
          t.string  :token
       end

       create_table :histories do |t|
          t.string :post_id
       end
    end
  end
end
