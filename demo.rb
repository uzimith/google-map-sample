require 'sinatra'
require "sinatra/activerecord"

#
# config
#
if development?
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
  set :bind, '0.0.0.0'
  set :port, 3000
end

#
# models
#
class Spot < ActiveRecord::Base
  validates :name, :lng, :lat, :image, presence: true
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
  spot = Spot.new({
    name: @params[:name],
    lat: @params[:lat],
    lng: @params[:lng],
    point: @params[:point],
    image: Base64.encode64(@params[:image][:tempfile].read),
    image_name: @params[:image][:filename],
    image_content_type: @params[:image][:type],
  })
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

get '/spot/:id/image' do
  @spot = Spot.find(@params[:id])
  content_type @spot.image_content_type
  Base64.decode64(@spot.image)
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
