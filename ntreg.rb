require_relative "hive"

hive = Hive.new(ARGV[0])

default_control_set = hive.relative_query("\\Select\\Default")


