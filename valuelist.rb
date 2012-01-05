def ValueList

	attr_accessor :number_of_values
	
	def initialize(hive, offset)
		header = hive[offset, 2]

		if header !~ /lf/ && header !~ /lh/
			puts "value list header broken at offset #{offset}"
		end

		@number_of_values = hive[offset+0x0002, 2].unpack('c').first
	end
end
