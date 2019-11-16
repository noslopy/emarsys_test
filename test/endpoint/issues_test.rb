# frozen_string_literal: true

require_relative '../test_helper.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

# rubocop:disable Metrics/BlockLength
describe 'Issues sinatra service' do
  before :all do
    Issue.delete_all
  end

  it 'runs' do
    get '/'
    assert last_response.ok?
    assert_equal 'Sinatra app is running', last_response.body
  end

  it 'returns issues from empty table' do
    get '/issues'
    assert last_response.ok?
    assert_equal [], JSON.parse(last_response.body)
  end

  it 'creates issue with submit-date within work hours' do
    post '/issues/new', name: 'task', description: 'a short task', turnaround: 8, submit_date: '2019-11-08 10:00:00'
    assert last_response.ok?
    assert_equal 1, Issue.count
  end

  it 'doesnt creates issue with submit-date outside of workhour' do
    post '/issues/new', name: 'task', description: 'a short task', turnaround: 8, submit_date: '2019-11-08 8:00:00'
    assert_equal 400, last_response.status
    assert last_response.body.include? 'Out of work hours'
    assert_equal 0, Issue.count
    post '/issues/new', name: 'task', description: 'a short task', turnaround: 8, submit_date: '2019-11-08 18:00:00'
    assert_equal 400, last_response.status
    assert last_response.body.include? 'Out of work hours'
    assert_equal 0, Issue.count
    post '/issues/new', name: 'task', description: 'a short task', turnaround: 8, submit_date: '2019-11-09 10:00:00'
    assert_equal 400, last_response.status
    assert last_response.body.include? 'Out of work hours'
    assert_equal 0, Issue.count
  end

  it 'updates issue' do
    test_issue = Issue.create(name: 'task', description: 'a medium task', turnaround: 16, submit_date: '2019-11-08 10:00:00')
    patch "/issues/#{test_issue.id}", name: 'updated_task'
    assert_equal Issue.last.name, 'updated_task'
  end

  it 'deletes issue' do
    test_issue = Issue.create(name: 'task', description: 'a medium task', turnaround: 16, submit_date: '2019-11-08 10:00:00')
    delete "/issues/#{test_issue.id}"
    assert Issue.count.zero?
  end

  it 'returns single issue with due-date on same day' do
    test_issue = Issue.create(name: 'task', description: 'a medium task', turnaround: 3, submit_date: '2019-11-08 10:00:00')
    get "/issues/#{test_issue.id}"
    assert last_response.ok?
    assert_equal test_issue.calculate_due_date, JSON.parse(last_response.body)['due_date']
    assert_equal Time.parse('2019-11-08').to_date, Time.parse(JSON.parse(last_response.body)['due_date']).to_date
  end

  it 'returns single issue with due-date on same week' do
    test_issue = Issue.create(name: 'task', description: 'a medium task', turnaround: 8, submit_date: '2019-11-07 10:00:00')
    get "/issues/#{test_issue.id}"
    assert last_response.ok?
    assert_equal test_issue.calculate_due_date, JSON.parse(last_response.body)['due_date']
    assert_equal Time.parse('2019-11-08').to_date, Time.parse(JSON.parse(last_response.body)['due_date']).to_date
  end

  it 'returns single issue with due-date on next week' do
    test_issue = Issue.create(name: 'task', description: 'a medium task', turnaround: 16, submit_date: '2019-11-08 10:00:00')
    get "/issues/#{test_issue.id}"
    assert last_response.ok?
    assert_equal test_issue.calculate_due_date, JSON.parse(last_response.body)['due_date']
    assert_equal Time.parse('2019-11-12').to_date, Time.parse(JSON.parse(last_response.body)['due_date']).to_date
  end
end
# rubocop:enable Metrics/BlockLength
