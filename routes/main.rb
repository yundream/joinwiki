# encoding: utf-8
require 'json'
class MyApp < Sinatra::Application
	before do
		@wiki = Wiki::Page.new('127.0.0.1', '5984', 'mywiki')
		@datadir = "data"
		@textdir = "#{@datadir}/text"
	end
	get "/*" do | path |
		@title = "Welcome to MyApp"				
		@json_data = @wiki.getPage "#{path}"
		@contents = JSON.parse(@json_data)
		erb :wiki
	end
	post "/*" do | path |
		data = request.body.read		
		jsondata = JSON.parse data
		@wiki.post(jsondata['_id'], data)
	end
end
