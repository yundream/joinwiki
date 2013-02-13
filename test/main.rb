Dir.chdir('../')
require_relative '../app'
require 'json'
require 'rack/test'

describe 'Joincwiki function test' do
	include Rack::Test::Methods
	def app
		MyApp
	end
=begin
    it "Page found" do
        get 'FrontPage'
		body = last_response.body
		puts body
    end 

    it "Page not found" do
	end
=end

=begin
    it "Page put success" do
		content = {:_id => "testwiki", :author=>"yundream", 
				:date=>"201302121745", :content=>"hello world", "tags"=>"test"}
		
        post 'mywiki', content.to_json, "CONTENT_TYPE" => "application/json"
		body = last_response.body
		puts body
    end 

=end
    it "Page delete success" do
		delete 'testwiki?', {:rev=>"1-e9d0d1b5b1d3d8fabd8e8f3a246b92b3"}
	end
	
    it "Page delete failure : page not found" do
	end

    it "Not found database" do
	end

    it "Time out" do
	end

end
