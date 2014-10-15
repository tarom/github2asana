#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'yaml'

CONFIG_PATH = File.expand_path('config.yml', File.dirname(__FILE__))
CONFIG = File.open(CONFIG_PATH) {|f| YAML.load(f).freeze } 

Octokit.auto_paginate = true

Asana.configure do |client|
  client.api_key = CONFIG['asana']['token']
end
octokit = Octokit::Client.new(access_token: CONFIG['github']['token'])

issues = octokit.list_issues("#{CONFIG['github']['name']}/#{CONFIG['github']['repos']}", milestone: CONFIG['github']['milestone_id'])

workspace = Asana::Workspace.all.first
project = Asana::Project.find(CONFIG['asana']['project_id'])

issues.each do |issue|
  next if CONFIG['github']['min_number'] and CONFIG['github']['min_number'].to_i > issue['number'].to_i
  assignee =
    if issue['assignee']
      CONFIG['assignees'][issue['assignee']['login']]
    else
      nil
    end
  next unless assignee
  task = workspace.create_task(
    name: "##{issue['number']} #{issue['title']}",
    notes: "#{issue['body']}\n\n#{issue["html_url"]}",
    assignee: assignee,
  )
  task.add_project(project.id)
  task.add_tag(CONFIG['asana']['tag_id']) if CONFIG['asana']['tag_id']
  sleep(0.1)
end
