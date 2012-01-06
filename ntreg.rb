require_relative "hive"

hive = Hive.new(ARGV[1])

if ARGV[0] != "rip_boot_key"
	hive.relative_query(ARGV[0])
else
	hive.rip_boot_key
end
