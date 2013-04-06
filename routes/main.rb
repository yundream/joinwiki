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
		view = <<END
{"language":"javascript","map":"function(doc) { if (doc.path == '#{path}') { emit(null, doc); }}"}
END
		@data = nil
		begin
			@data = @wiki.findPage view 
		rescue WikiError => e
			if (e.code == 404)
				redirect "/w/#{path}?type=notfound"
			end
		end
		@contents = @data['rows'][0]['value']
		@yy=@contents['createtime'][0,4]
		@mm=@contents['createtime'][4,2]
		@dd=@contents['createtime'][6,2]
		@hh=@contents['createtime'][8,2]
		@ii=@contents['createtime'][10,2]
		@path=path
		erb :view
	end

	get "/find" do 
	end

	get "/w/:name" do | path |
		@title = "Make page #{path}"
		@editor = :editor
		@path = path
		erb :wiki
	end

	get "/e/:name" do | path |
		@json_data = @wiki.getPage "#{path}"
		@contents = JSON.parse(@json_data)
		@path = path
		@title = "#{params['type']} page #{path}"
		@editor = :editor
		@type = "edit" 
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
		id = (0...32).map{ ('a'..'z').to_a[rand(26)] }.join
		params[:createtime] = time.strftime("%Y%m%d%H%M")
		params[:path] = path 
		params[:_rev] = "1-5dc77729caea77842015c9eeb53efd84" 
		data = JSON params
		begin
			@wiki.sendPage("vkjbpvyahuyqivhwldvsneffandapcta", data)
		rescue WikiError => e
			puts "ERROR ";
		end
	end
end
