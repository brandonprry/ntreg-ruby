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

		@root_key.lf_record.children.each do |child|			
			next if child.name != paths[1]

			@current_child = child
			full_name = child.name
		
			if paths.length == 2
				if @current_child.lf_record
					puts "The children of \\#{@root_key.name}\\#{full_name} are: "
                                        @current_child.lf_record.children.each do |c|
                                                p c.name
                                        end
				end                                        
                                if @current_child.value_list
                                        puts "The values and data of \\#{@root_key.name}\\#{full_name} are: "

                                        @current_child.value_list.values.each do |value|
                                                p value.name
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
							p c.name
						end
					end
						
					if @current_child.value_list
						puts "The values and data of \\#{@root_key.name}\\#{full_name} are: "
							
						@current_child.value_list.values.each do |value|
							p value.name 
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
end
