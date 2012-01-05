class NodeKey

	attr_accessor :timestamp, :parent_offset, :subkeys_count, :lf_record_offset
	attr_accessor :value_count, :value_list_offset, :security_key_offset
	attr_accessor :class_name_offset, :name_length, :class_name_length
	attr_accessor :name

	def initialize(hive, offset)	

		offset = offset + 0x04		
	
		nk_header = hive[offset, 2]
		nk_type = hive[offset+0x02, 2]

		puts nk_header
		puts nk_type		

		if nk_header !~ /nk/ || nk_type !~ /,/
			puts "root key broken"
			return
		end
	
		@timestamp = hive[offset+0x04, 8].unpack('q').first
		@parent_offset = hive[offset+0x10, 4].unpack('l').first
		@subkeys_count = hive[offset+0x14, 4].unpack('l').first
		@lf_record_offset = hive[offset+0x1c, 4].unpack('l').first
		@value_count = hive[offset+0x24, 4].unpack('l').first
		@value_list_offset = hive[offset+0x28, 4].unpack('l').first
		@security_key_offset = hive[offset+0x2c, 4].unpack('l').first
		@class_name_offset = hive[offset+0x30, 4].unpack('l').first
		@name_length = hive[offset+0x48, 2].unpack('c').first
		@class_name_length = hive[offset+0x4a, 2].unpack('c').first
		@name = hive[offset+0x4c, @name_length].to_s
	end

end
