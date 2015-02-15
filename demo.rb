require 'sinatra'
require "sinatra/activerecord"

# config
set :database, {adapter: "sqlite3", database: "database.sqlite3"}
set :bind, '0.0.0.0'
set :port, 3000

# models
class Spot < ActiveRecord::Base
  validates :name, :lng, :lat, presence: true
end

# routes

get '/' do
  @spots = Spot.all
  erb :index, layout: :top
end

get '/add' do
  erb :add
end

post '/create' do
  spot = Spot.new(@params)
  if spot.save
    redirect "/"
  else
    erb :add
  end
end

get '/spot/:id' do
  @spot = Spot.find(@params[:id])
  erb :spot
end
