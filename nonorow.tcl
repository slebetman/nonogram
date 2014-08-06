#! /usr/bin/env tclsh

proc sum {numbers} {
	expr [join $numbers +]
}

proc split_row {n m} {
	if {$m <= 1} {
		return $n
	} else {
		set result {}
		for {set x 1} {$x <= ($n-$m+1)} {incr x} {
			foreach y [split_row [expr $n-$x] [expr $m-1]] {
				lappend result [list $x {*}$y]
			}
		}
		return $result
	}
}

proc process_row {n m} {
	set result {}
	foreach x [split_row [expr $n+2] $m] {
		lset x 0 [expr [lindex $x 0]-1]
		lset x end [expr [lindex $x end]-1]
		lappend result $x
	}
	return $result
}

proc nonorow {ngram row} {
	set row_remainder [expr $row-[sum $ngram]]
	
	if {$row_remainder < ([llength $ngram]-1)} {
		error "Row not large enough to contain nonogram!"
	}
	
	set result {}
	foreach x [process_row $row_remainder [expr [llength $ngram]+1]] {
		set line ""
		foreach blank $x paint $ngram {
			append line [string repeat " " $blank]
			append line [string repeat "#" [expr $paint+0]]
		}
		lappend result $line
	}
	return $result
}

puts [join [nonorow [lindex $argv 0] [lindex $argv 1]] \n]
