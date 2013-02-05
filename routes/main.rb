# encoding: utf-8
class MyApp < Sinatra::Application
	before do
		@wiki =  
	end
	get "/*" do | path | 
		@title = "Welcome to MyApp"				
		puts path
		haml :main
	end
	post "/*" do | path |
	end
end
