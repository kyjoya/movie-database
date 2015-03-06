require 'sinatra'
require 'pg'
require 'pry'
load 'helpers.rb'

get '/actors' do

  erb :'actors/index'
end

get '/actors/:id' do

  erb :'actors/show', locals: { actor_id: params[:id] }
end

get '/movies' do

  erb :'movies/index'
end

get '/movies/:id' do

  erb :'movies/show', locals: { movie_id: params[:id] }
end
