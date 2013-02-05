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
        get '/Site/Linux'
    end 
end
