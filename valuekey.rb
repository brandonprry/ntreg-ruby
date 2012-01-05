def ValueKey

	attr_accessor :name_length, :length_of_data, :data_offset
	attr_accessor :value_type, :name, :value

	def initialize(hive, offset)

		vk_header = hive[offset, 2]
		
		if vk_header !~ /vk/
			puts "no vk at offset #{offset}"
			return
		end

		@name_length = hive[offset+0x0002, 2].unpack('c').first
		@length_of_data = hive[offset+0x0004, 4].unpack('l').first
		@data_offset = hive[offset+ 0x0008, 4].unpack('l').first
		@value_type = hive[offset+0x000C, 4]
		
		flag = hive[offset+0x0010, 2].unpack('c').first
		
		if flag == 0
			@name = "Default"
		else
			@name = hive[offset+0x0014, @name_length].to_s
		end

		
	end
end
