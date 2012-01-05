require "nodekey"

class Hive
	attr_accessor :root_key

	def initialize(hivepath)
		
		hive_blob = File.read(hivepath)	

		@root_key = NodeKey.new(hive_blob,0x1020 + 1)

		puts "Found root key: " + @root_key.name
	end

	def query(path)
		if !@root_key
			puts "Please set your root key with get_root_key"
			return
		end

		@children
	end
end
