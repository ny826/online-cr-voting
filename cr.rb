require 'sinatra'
require 'data_mapper'

set :sessions,true

DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/pankaj.db")
 
class User
 	include DataMapper::Resource
 	property :id,Serial
 	property :enrollment,Integer
 	property :name,String
 	property :password,String
 	property :branch,String
 end
 class Rajiv
    include DataMapper::Resource
 	property :id,Serial
 	property :voter,Integer
 	property :cr,Integer	
 end

 class Hanu
    include DataMapper::Resource
 	property :id,Serial
 	property :voter,Integer
 	property :cr,Integer	
 end
 DataMapper.finalize
DataMapper.auto_upgrade!


get '/' do 
	erb :login
end

post '/signin' do
	name=params[:name]
	password=params[:password]
	enrollment_no=params[:roll_no]
	branch=params[:branch]
    user=User.all(:enrollment=>enrollment_no,:password=>password,:name=>name,:branch=>branch).first
    if user
    	puts "in signin if statement"
    	session[:user_id]=user.id
    	redirect '/page/branch'
    else
    redirect '/register'
    end
end

get '/register' do

erb :register
end

post '/register' do

	puts "in register "
    name=params[:name]
    puts "name is #{params[:name]}"
	password=params[:password]
    puts "password is #{params[:password]}"

	enrollment=params[:roll_no]
	puts "enrollment_no is #{params[:roll_no]}"

	branch=params[:branch]
    puts "branch is #{params[:branch]}"

    user=User.new
    
    user.enrollment=enrollment
    user.name=name
    user.password=password
    user.branch=branch
    user.save
    session[:user_id]=user.id


    puts "session user id is : #{session[:user_id]}"
    redirect '/page/branch'
end

get '/page/:cse' do
puts "Hello Cse"
erb :cse
end

get '/rajiv' do 
puts "in get rajiv "
rajiv=Rajiv.new
user=User.get(session[:user_id])
rajiv.voter=user.enrollment
rajiv.cr=70116403215
rajiv.save
redirect '/logout'
end

get '/hanu' do 
puts "in get hanu "
hanu=Hanu.new
user=User.get(session[:user_id])
hanu.voter=user.enrollment
hanu.cr=01016403215
hanu.save
redirect '/logout'
end

get '/logout' do
session[:user_id]=nil
redirect '/'
end