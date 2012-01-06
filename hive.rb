require_relative "regf"
require_relative "nodekey"

class Hive
	attr_accessor :root_key

	def initialize(hivepath)
		
		hive_blob = open(hivepath, "rb") { |io| io.read }	
		hive_regf = RegfBlock.new(hive_blob)
	
		@root_key = NodeKey.new(hive_blob, 0x1000 + hive_regf.root_key_offset)

		puts "Found root key: " + @root_key.name if @root_key
	end

	def relative_query(path)

		paths = path.split("\\")
		
		1.upto(@root_key.subkeys_count) do |k|
			
		end
	end
end
