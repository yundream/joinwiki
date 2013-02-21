# encoding: utf-8
require 'json'
class MyApp < Sinatra::Application
	before do
		@wiki = Wiki::Page.new('127.0.0.1', '5984', 'mywiki')
		@datadir = "data"
		@textdir = "#{@datadir}/text"
	end

	# Read page
	get "/wiki/:name" do | path |
		@title = "Read Page #{path}"
		begin
			@json_data = @wiki.getPage "#{path}"
			@contents = JSON.parse(@json_data)
		rescue WikiError => e
			if (e.code == 404)
				redirect "/w/#{path}"
			end
		end
	end

	get "/w/:name" do | path |
		@title = "Make page #{path}"
		@editor = "<textarea id=\"editor\"></textarea>"
		erb :wiki
	end

	# delete page	
	delete "/wiki/:name" do | path |
		params[:rev]
		@title = "Delete page : #{path}"
		begin
			@json_data = @wiki.deletePage "#{path}", params[:rev]
		rescue WikiError => e
		end
	end

	# Post Page 
	post "/wiki/:name" do | path |
		data = request.body.read		
		jsondata = JSON.parse data
		begin
			@wiki.sendPage(jsondata['_id'], data)
		rescue WikiError => e
		end
	end

end
