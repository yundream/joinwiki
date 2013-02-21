Dir.chdir('../')
require_relative '../app'
require 'json'
require 'rack/test'

describe 'Joincwiki function test' do
	include Rack::Test::Methods
	def app
		MyApp
	end
    it "Get page success" do
        get '/wiki/testwiki'
		body = last_response.body
		puts body
    end 

=begin
    it "Get page failure" do
		get 'nonepage'
	end
    it "Create page" do
		content = {:_id => "testwiki", :author=>"yundream", 
				:date=>"201302121745", :content=>"hello world", "tags"=>"test"}
		
        post 'mywiki', content.to_json, "CONTENT_TYPE" => "application/json"
		body = last_response.body
		puts body
    end 

    it "Delete wikipage" do
		delete 'testwiki', {:rev=>'3-d3aee0e660d0fdb0b9261b906d9b7969'}
	end
=end

end
