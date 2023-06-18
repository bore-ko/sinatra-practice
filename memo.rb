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

  def memo_lines
    id = params[:id].delete(':')
    conn = PG.connect(dbname: 'memos')
    @memos = conn.exec('SELECT * FROM memos WHERE id = $1;', [id])
    conn.finish
  end
end

get '/' do
  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec('SELECT * FROM memos;')
  conn.finish
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  conn = PG.connect(dbname: 'memos')
  conn.exec('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
  conn.finish
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
  conn = PG.connect(dbname: 'memos')
  conn.exec('UPDATE memos SET title=$1, content=$2 WHERE id=$3;', [title, content, id])
  conn.finish
  redirect '/'
end

delete '/memos/:id' do
  id = params[:id].delete(':')
  conn = PG.connect(dbname: 'memos')
  conn.exec('DELETE FROM memos WHERE id=$1;', [id])
  conn.finish
  redirect '/'
end
