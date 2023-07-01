# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'csv'
require 'erb'
require 'pg'

helpers do
  def h(text)
    ERB::Util.html_escape(text)
  end

  def connect_memos
    PG.connect(dbname: 'memos')
  end

  def memo_lines
    id = params[:id].delete(':')
    @memos = connect_memos.exec('SELECT * FROM memos WHERE id = $1;', [id])
    connect_memos.finish
  end
end

get '/' do
  @memos = connect_memos.exec('SELECT * FROM memos;')
  connect_memos.finish
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  connect_memos.exec('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
  connect_memos.finish
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
  id = params[:id].delete(':')
  title = params[:title]
  content = params[:content]
  connect_memos.exec('UPDATE memos SET title=$1, content=$2 WHERE id=$3;', [title, content, id])
  connect_memos.finish
  redirect '/'
end

delete '/memos/:id' do
  id = params[:id].delete(':')
  connect_memos.exec('DELETE FROM memos WHERE id=$1;', [id])
  connect_memos.finish
  redirect '/'
end
