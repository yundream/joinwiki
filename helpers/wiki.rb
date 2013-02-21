require 'net/http'

class WikiError < Exception;
	def initialize(code)
		@code = code
	end
	attr :code
end
module Wiki
	class Page
		def initialize (host, port, dbname)
			@db = CouchDB.new(host, port, dbname)
		end

		def getPage id 
			begin
				return (@db.get id).body
			rescue RuntimeError, Net::HTTPBadResponse => e
				case e.message
					when /404/ then code = 404
					when /500/ then code = 500
				end
				raise WikiError.new code 
			end
		end

		def sendPage id, data
			begin
			response=@db.put id, data
			rescue RuntimeError, Net::HTTPBadResponse => e
				case e.message
					when /404/ then code = 404 
					when /500/ then code = 500 
				end
				raise WikiError.new code 
			end
		end
		def deletePage id, rev 
			begin
				@db.delete id, rev
				puts 'delete success'
			rescue RuntimeError, Net::HTTPBadResponse => e
				puts e.message
				case e.message
					when /404/ then code = 404 
					when /500/ then code = 500 
					when /409/ then code = 409 
				end
				raise WikiError.new code 
			end
		end
	end

	class CouchDB
		def initialize(host, port, dbname)
			@host = host
			@port = port
			@dbname = dbname
		end

		def opendb(dbname)
			@dbname = dbname
		end

		def delete(id, rev)
			request(Net::HTTP::Delete.new("/#{@dbname}/#{id}?rev=#{rev}"))
		end

		def get(id)
			request(Net::HTTP::Get.new("/#{@dbname}/#{id}"))
		end

		def put(id, json)
			req = Net::HTTP::Put.new("/#{@dbname}/#{id}")
			req["content-type"] = "application/json"
			req.body = json
			request(req)
		end

		def post(id, json)
			req = Net::HTTP::Post.new("/#{@dbname}/#{id}")
			req["content-type"] = "application/json"
			req.body = json
			request(req)
		end

		def request(req)
			res = Net::HTTP.start(@host, @port) { |http|http.request(req) }
			unless res.kind_of?(Net::HTTPSuccess)
				handle_error(req, res)
			end
			res
		end

		private

		def handle_error(req, res)
			e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD:#{req.method}\nURI:#{req.path}\n#{res.body}")
			raise e
		end
	end
end
