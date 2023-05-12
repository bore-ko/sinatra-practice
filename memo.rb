# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'csv'
require 'erb'

include ERB::Util

get '/' do
  @memos = CSV.read('memo.csv')
  @memos.shift
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  if File.empty?('memo.csv')
    CSV.open('memo.csv', 'w') do |csv|
      csv << %w[id title content]
      csv << [SecureRandom.uuid, html_escape(params[:title].to_s), html_escape(params[:content].to_s)]
    end
  else
    CSV.open('memo.csv', 'a') do |csv|
      csv << [SecureRandom.uuid, html_escape(params[:title].to_s), html_escape(params[:content].to_s)]
    end
  end
  redirect '/'
end

get '/memos/:id' do
  @id = params[:id]
  @memos = CSV.read('memo.csv')
  erb :detail
end

get '/memos/:id/edit' do
  @id = params[:id]
  memos = CSV.read('memo.csv')
  memos.each do |memo|
    if params[:id] == ":#{memo[0]}"
      @title = memo[1]
      @content = memo[2]
    end
  end
  erb :edit
end

patch '/memos/:id' do
  memos = CSV.read('memo.csv')
  memos.each do |memo|
    if params[:id] == ":#{memo[0]}"
      memo[1] = html_escape(params[:title].to_s)
      memo[2] = html_escape(params[:content].to_s)
    end
  end
  CSV.open('memo.csv', 'w') do |csv|
    memos.each do |memo|
      csv << memo
    end
  end
  redirect '/'
end

delete '/memos/:id' do
  memos = CSV.read('memo.csv')
  memos.each do |memo|
    memos.delete(memo) if params[:id] == ":#{memo[0]}"
  end
  CSV.open('memo.csv', 'w') do |csv|
    memos.each do |memo|
      csv << memo
    end
  end
  redirect '/'
end
