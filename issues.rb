# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require './models/issues.rb'

set :database_file, './config/database.yml'
register Sinatra::ActiveRecordExtension

get '/' do
  content_type 'application/json'

  status 200
  body 'Sinatra app is running'
end

get '/issues' do
  content_type 'application/json'

  Issue.all.to_json
end

post '/issues/new' do
  content_type 'application/json'

  begin
    status 200
    Issue.create!(
      name: params[:name],
      description: params[:description],
      turnaround: params[:turnaround],
      submit_date: params[:submit_date]
    )
  rescue StandardError => e
    status 400
    "Error: #{e.message}"
  end
end

patch '/issues/:issue_id' do
  content_type 'application/json'

  begin
    status 200
    update_params = params.slice(:name, :description, :turnaround)
    issue = Issue.find(params[:issue_id])
    issue.update!(update_params)
  rescue StandardError => e
    status 400
    "Error: #{e.message}"
  end
end

delete '/issues/:issue_id' do
  content_type 'application/json'

  begin
    status 200
    Issue.delete(params[:issue_id])
  rescue StandardError => e
    status 400
    "Error: #{e.message}"
  end
end

get '/issues/:issue_id' do
  content_type 'application/json'

  begin
    status 200
    issue = Issue.find(params[:issue_id])
    issue_hash = JSON.parse(issue.to_json)
    issue_hash['due_date'] = issue.calculate_due_date
    issue_hash.to_json
  rescue StandardError => e
    status 400
    "Error: #{e.message}"
  end
end
