
proc BoxProp { shape } {
	scan $shape "B%dX%f" b t;
	set Aw [expr $b*$b];
	set edgeh [expr $b-2*$t];
	set Ah [expr $edgeh*$edgeh];
	set A [expr $Aw-$Ah];                                     # lindex 3
	set Iw [expr pow($b,4)/12];                                
	set edgeh [expr $b-2*$t];                                  
	set Ih [expr pow($edgeh,4)/12];                            
	set Ix [expr round([expr ($Iw-$Ih)*1000])/1000.0];        # lindex 4
	set Zx [expr round([expr $Ix*2.0/$b*1000])/1000.0];       # lindex 5
	set ry [expr round([expr sqrt($Ix/$A)*1000])/1000.0];     # lindex 6
	set Prop [list $shape $b $t $A $Ix $Zx $ry];
	return $Prop
}