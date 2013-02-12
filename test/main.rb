Dir.chdir('../')
require_relative '../app'
require 'json'
require 'rack/test'

describe 'Joincwiki function test' do
	include Rack::Test::Methods
	def app
		MyApp
	end
    it "FrontPage read test" do
        get 'FrontPage'
		body = last_response.body
		puts body
    end 

    it "Page add test" do
		content = {:_id => "testwiki", :author=>"yundream", 
				:date=>"201302121745", :content=>"hello world", "tags"=>"test"}
		
        post 'Mywiki', content.to_json, "CONTENT_TYPE" => "application/json"
		body = last_response.body
		puts body
    end 
end
