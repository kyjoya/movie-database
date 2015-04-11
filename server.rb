require 'sinatra'
require 'pg'
require 'pry'
load 'helpers.rb'


def movies
  order = params[:order] || "title"
  db_connection do |conn|
  conn.exec("SELECT movies.id, movies.title, movies.year, movies.rating, genres.name AS genre, studios.name AS studio FROM movies
      JOIN genres ON movies.genre_id = genres.id
      LEFT OUTER JOIN studios ON movies.studio_id = studios.id
      ORDER BY movies.#{order}")
    end
end

def movie_search
  search = params[:search]
  db_connection do |conn|
  conn.exec("SELECT movies.id, movies.title, movies.year, movies.rating, genres.name AS genre, studios.name AS studio FROM movies
      JOIN genres ON movies.genre_id = genres.id
      LEFT OUTER JOIN studios ON movies.studio_id = studios.id
      WHERE movies.title = '#{search}'")
    end
end

def movie_data
movie_id = params[:id]
db_connection do |conn|
conn.exec("SELECT movies.id, movies.title, movies.year, movies.rating, genres.name AS genre, studios.name AS studio FROM movies
    JOIN genres ON movies.genre_id = genres.id
    LEFT OUTER JOIN studios ON movies.studio_id = studios.id
    WHERE movies.id = #{movie_id}")
  end
end

def cast_data
movie_id = params[:id]
db_connection do |conn|
conn.exec("SELECT actors.id, actors.name, cast_members.character FROM cast_members
      JOIN actors ON cast_members.actor_id = actors.id
      WHERE cast_members.movie_id = #{movie_id}")
  end
end

def actors
db_connection do |conn|
conn.exec("SELECT actors.id, name FROM actors
      ORDER BY name")
  end
end

def movies_data_with_actor_id
actor_id = params[:id]
db_connection do |conn|
  conn.exec("SELECT movies.id, movies.title, actors.name, cast_members.character FROM cast_members
        JOIN movies ON cast_members.movie_id = movies.id
        JOIN actors ON cast_members.actor_id = actors.id
        WHERE cast_members.actor_id = #{actor_id}")
  end
end

def movie_page_display
  if params[:search].nil? 
    movies
  elsif params[:search]
    movie_search
  end
end

###########################################################################
get '/' do
  redirect '/movies'
end

get '/actors' do
  @actors = actors
  erb :'actors/index'
end

get '/actors/:id' do
  @movies_data_with_actor_id = movies_data_with_actor_id
  erb :'actors/show', locals: { actor_id: params[:id] }
end

get '/movies' do
  movie_page_display

  @movie_table = movies
  @search_result = movie_search

  erb :'movies/index'
end

get '/movies/:id' do
  @movie_data = movie_data
  @cast_data = cast_data

  erb :'movies/show', locals: { movie_id: params[:id] }
end
