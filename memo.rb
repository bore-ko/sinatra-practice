# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'csv'
require 'erb'

helpers do
  def h(text)
    ERB::Util.html_escape(text)
  end

  def memo_lines
    @memos = CSV.read('memo.csv').find { |memo| memo if params[:id] == ":#{memo[0]}" }
  end
end

get '/' do
  @memos = CSV.read('memo.csv', headers: true)
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  CSV.open('memo.csv', 'a') do |csv|
    csv << %w[id title content] if File.empty?('memo.csv')
    csv << [SecureRandom.uuid, params[:title], params[:content]]
  end
  redirect '/'
end

get '/memos/:id' do
  memo_lines
  erb :detail
end

get '/memos/:id/edit' do
  memo_lines
  erb :edit
end

patch '/memos/:id' do
  memos = CSV.read('memo.csv')
  memo_lines
  lines = memos.find { |memo| memo == @memos }
  lines[1] = params[:title]
  lines[2] = params[:content]
  CSV.open('memo.csv', 'w') do |csv|
    memos.each do |memo|
      csv << memo
    end
  end
  redirect '/'
end

delete '/memos/:id' do
  memos = CSV.read('memo.csv')
  memo_lines
  memos.delete_if { |memo| memo == @memos }
  CSV.open('memo.csv', 'w') do |csv|
    memos.each do |memo|
      csv << memo
    end
  end
  redirect '/'
end
