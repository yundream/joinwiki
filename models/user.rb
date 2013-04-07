# encoding: utf-8


DB=Sequel.sqlite('db/users.db')

unless DB.table_exists?(:users)
	DB.create_table :users do
		primary_key :id
		String :user_name, :size=>64
		String :user_id, :size=>64, :unique=>true
		String :password, :size=>64
		DateTime :created
	end
end

class User < Sequel::Model
	plugin :serialization, :json, :json_serializer
end
