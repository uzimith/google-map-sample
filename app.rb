require 'sinatra'
require "sinatra/activerecord"
require './models/comment.rb'
require './models/spot.rb'

if development?
  require 'sinatra/reloader'
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
  set :bind, '0.0.0.0'
  set :port, 3000
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

# ----------
#   routes
# ----------

get '/' do
  @spots = Spot.all
  erb :index, layout: :top
end

# スポット

get '/spot/add' do
  erb :add
end

post '/spot/create' do
  unless @params[:image]
    @error = true
    erb :add
  else
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
      @error = true
      erb :add
    end
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
