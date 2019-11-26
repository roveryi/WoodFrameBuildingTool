# Define pushover loading

puts $chanLog "pattern Plain 200 Linear {";

# pattern Plain 200 Linear {

	# # Pushover pattern
	# for {set y 2} {$y <= $NLevel} {incr y} {
		# RunLog "load [format %s%s%s $y 0 02] $Cvx(Storey[expr $y - 1]) 0 0 0 0 0";

		# puts "Level $y: Load factor $Cvx(Storey[expr $y - 1])!"
	# }

# }

pattern Plain 200 Linear {

	# Pushover pattern
	# for {set y 2} {$y <= $NLevel} {incr y} {
		# RunLog "load [format %s%s%s 44 0 02] 1000 0 0 0 0 0";
		load 211019 1000 0 0 0 0 0;

		# puts "Level $y: Load factor $Cvx(Storey[expr $y - 1])!"
	# }

}

puts "Pushover load in X direction defined"
puts $chanLog "}";
puts $chanLog "# Pushover load in X direction defined";
