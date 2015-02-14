require 'sinatra'
require "sinatra/activerecord"
require 'sinatra/reloader' if development?

# config
set :database, {adapter: "sqlite3", database: "database.sqlite3"}
set :bind, '0.0.0.0'
set :port, 3000

# models
class Store < ActiveRecord::Base
  validates :name, :lng, :lat, presence: true
end

# routes

get '/' do
  @stores = Store.all
  erb :index, layout: :top
end

get '/add' do
  erb :add
end

post '/create' do
  store = Store.new(@params)
  if store.save
    redirect "/"
  else
    erb :add
  end
end

get '/store/:id' do
  @store = Store.find(@params[:id])
  erb :store
end
