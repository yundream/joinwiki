# encoding: utf-8
# -*- coding: utf-8 -*-
require 'json'
require 'pp'
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
			@yy=@contents['createtime'][0,4]
			@mm=@contents['createtime'][4,2]
			@dd=@contents['createtime'][6,2]
			@hh=@contents['createtime'][8,2]
			@ii=@contents['createtime'][10,2]
		rescue WikiError => e
			if (e.code == 404)
				redirect "/w/#{path}"
			end
		end
		erb :view
	end

	get "/w/:name" do | path |
		@title = "Make page #{path}"
		@editor = :editor
		@path = path
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
		time = Time.new
		#puts params[:message]
		#puts params[:author]
		#data = request.body.read
		#jsondata = JSON.parse data
		params[:createtime] = time.strftime("%Y%m%d%H%M")
		params[:_id] = path 
		data = JSON params
		begin
			@wiki.sendPage(path, data)
		rescue WikiError => e
			puts "ERROR ";
		end
	end
end
