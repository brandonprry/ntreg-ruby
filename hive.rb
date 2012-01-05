require_relative "regf"
require_relative "nodekey"

class Hive
	attr_accessor :root_key

	def initialize(hivepath)
		
		hive_blob = File.read(hivepath)	
	
		hive_regf = RegfBlock.new(hive_blob)

		if hive_regf.hive_name =~ /SAM/
			@root_key = NodeKey.new(hive_blob, 4128)
		elsif hive_regf.hive_name =~ /SYSTEM/
			@root_key = NodeKey.new(hive_blob, 4125)
		elsif hive_regf.hive_name =~ /SOFTWARE/
			@root_key = NodeKey.new(hive_blob, 4128)
		elsif hive_regf.hive_name =~ /DEFAULT/
			@root_key = NodeKey.new(hive_blob, 4126)
		else
			puts "Don't know what kind of hive this is."
			return
		end

		#@root_key = NodeKey.new(hive_blob, 4128)

		puts "Found root key: " + @root_key.name if @root_key
	end

	def relative_query(path)

		paths = path.split("\\")
		
		@root_key.children.each do |child|

		
		end
	end
end
