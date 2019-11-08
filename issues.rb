# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'

set :database_file, './config/database.yml'
register Sinatra::ActiveRecordExtension

get '/' do
  content_type 'application/json'

  'Hello'
end

get '/issues' do
  content_type 'application/json'

  [1, 2, 3, 4].to_json
end

post '/issues/new' do
  { asd: 'asd' }.to_json
end

patch '/issues/issue_id' do |issue_id|
  { asd: issue_id }.to_json
end

delete '/issues/issue_id' do |issue_id|
  { asd: issue_id }.to_json
end

get '/issues/:issue_id' do |issue_id|
  content_type   'application/json'

  { asd: issue_id }.to_json
end
