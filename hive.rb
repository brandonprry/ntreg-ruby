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

		if path == "" || path == "\\"

			puts "The children of the rootkey are as follows:"
			@root_key.lf_record.children.each do |child|
				p child.name
			end
		end

		paths = path.split("\\")

		@root_key.lf_record.children.each do |child|			
			next if child.name != paths[1]

			@current_child = child
			full_name = child.name
		
			if paths.length == 2
				if @current_child.lf_record
					puts "The children of \\#{@root_key.name}\\#{full_name} are: "
                                        @current_child.lf_record.children.each do |c|
                                                p c.name + " :: Classname: " + c.class_name_data
                                        end
				end                                        
                                if @current_child.value_list
                                        puts "The values and data of \\#{@root_key.name}\\#{full_name} are: "

                                        @current_child.value_list.values.each do |value|
                                                p value.name + ": " + value.value.data
                                        end
                                end

				break
			end			

			
			2.upto(paths.length) do |i|

				if i == paths.length
					#p @current_child.value_list.values

					if @current_child.lf_record
 						puts "The children of \\#{@root_key.name}\\#{full_name} are: "
	                        
				               	@current_child.lf_record.children.each do |c|
							p c.name + " :: Classname: " + c.class_name_data
						end
					end
						
					if @current_child.value_list != nil
						puts "The values and data of \\#{@root_key.name}\\#{full_name} are: "
							
						@current_child.value_list.values.each do |value|
							p value.name + ": " + (value.value.data ? value.value.data : "")
						end
					end
				else
					if @current_child.lf_record
						@current_child.lf_record.children.each do |c|
							next if c.name != paths[i]
							
							@current_child = c
							full_name << "\\#{c.name}"
							
							break
						end
					end
				end
		
			end
			
		end
	end

	def rip_boot_key
		scrambled_key = []
		default_control_set = ""
		
		@root_key.lf_record.children.each do |node|
			next if node.name != "Select"
		
			node.value_list.values.each do |value|
				next if value.name != "Default"
		
				default_control_set = "ControlSet00" + value.value.data.unpack('c').first.to_s
			end
		end

		puts "Default Control Set: " + default_control_set

		@root_key.lf_record.children.each do |node|
			next if node.name != default_control_set
			
			node.lf_record.children.each do |cchild|
				next if cchild.name != "Control"
				
				puts "Found: " + cchild.name

				cchild.lf_record.children.each do |lsachild|
					next if lsachild.name != "Lsa"

					puts "Found: " + lsachild.name

					%w[JD Skew1 GBG Data].each do |key|
						lsachild.lf_record.children.each do |child|
							next if child.name != key
	
							puts "Found: " + child.name
		
							child.class_name_data.each_byte do |byte|
								scrambled_key << byte if byte != 0x00 
							end
						end
					end
				end

			end
		end

		scrambler = [ 0x8, 0x5, 0x4, 0x2, 0xb, 0x9, 0xd, 0x3, 0x0, 0x6, 0x1, 0xc, 0xe, 0xa, 0xf, 0x7 ]
		bootkey = scrambled_key	

		0.upto(0x10-1) do |i|
			#p scrambler[i]
			bootkey[i] = scrambled_key[scrambler[i]]
		end
		
		puts "Bootkey: " + bootkey.to_s
	end
end
