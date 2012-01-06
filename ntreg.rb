require_relative "hive"

hive = Hive.new(ARGV[1])

hive.relative_query(ARGV[0])


