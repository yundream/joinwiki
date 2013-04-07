require 'json'
require 'pp'
class MyApp < Sinatra::Application
	before do
		@wiki = Wiki::Page.new('127.0.0.1', '5984', 'mywiki')
		@datadir = "data"
		@textdir = "#{@datadir}/text"
	end

	get '/user/login' do
		erb :login
	end

	post '/user/login' do
		items = User.filter(:user_id=>params[:user_id]).filter(:password=>params[:password])
		items.each do |item|
			puts item[:user_name]
			puts item[:created]
		end
		erb :login
	end

	get '/user/register' do
		erb :register
	end

	post '/user/register' do
		post_data = Hash.new 
		post_data[:user_name] = params[:user_name]
		post_data[:password] = params[:password]
		post_data[:user_id] = params[:user_id] 
		post_data[:created] = Time.now
		User.create(post_data)
		redirect '/user/login' 
	end
	

	get '/foo' do
		session['m'] = "Hello world"
		redirect "/bar"
	end

	get '/bar' do
		<<ENDRESPONSE
Ruby:   #{RUBY_VERSION}
Ruby:   #{Sinatra::VERSION}
#{session['m'].inspect}
ENDRESPONSE
	end
end
