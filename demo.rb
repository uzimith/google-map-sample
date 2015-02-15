require 'sinatra'
require "sinatra/activerecord"

#
# config
#
set :database, {adapter: "sqlite3", database: "database.sqlite3"}
set :bind, '0.0.0.0'
set :port, 3000

#
# models
#
class Spot < ActiveRecord::Base
  validates :name, :lng, :lat, presence: true
  has_many :comments
end

class Comment < ActiveRecord::Base
  validates :name, :text, presence: true
  belongs_to :spot, counter_cache: true
end

#
# routes
#

get '/' do
  @spots = Spot.all
  erb :index, layout: :top
end

# スポット

get '/spot/add' do
  erb :add
end

post '/spot/create' do
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

# コメント

post '/comment/create' do
  comment = Comment.new({
    spot_id: @params[:spot_id],
    name: @params[:name],
    text: @params[:text],
  })
  if comment.save
    redirect "/spot/#{@params[:spot_id]}"
  else
    @spot = Spot.find(@params[:spot_id])
    erb :spot
  end
end

# ランキング

get '/rank' do
  @recent = Comment.order("updated_at DESC").limit(10)
  @popular = Spot.order("comments_count DESC").limit(10)
  erb :rank
end
