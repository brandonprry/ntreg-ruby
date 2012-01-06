class RegfBlock
	
	attr_accessor :timestamp, :root_key_offset, :hive_name

	def initialize(hive)
	
		regf_header = hive[0x00, 4]
		
		if regf_header !~ /regf/
			puts "Not a registry hive"
		
			return
		end

		@timestamp = hive[0x0C, 8].unpack('q').first
		@root_key_offset = 0x20
		@hive_name = hive[0x30-1, 64].to_s.gsub("\x00", "")

		#puts "Timestamp: #{@timestamp.inspect}"
		#puts "Root key offset: #{@root_key_offset.inspect}"
		puts "Hive name: #{@hive_name.inspect}"		
	end
end
