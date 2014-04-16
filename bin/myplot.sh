

#!/bin/bash  
echo "the data have dealed,we will paint the pic"  
  
gnuplot << FFF
	set terminal png truecolor  
	set output "test.png"  
	
	set ylabel "Times"          
	set xlabel  "latency(microseconds)"  
	set title "Different latency under different interval with cyclictest"  
	set logscale y  
	plot "hist_p4_i100" with lines, "hist_p4_i400" with lines ,"hist_p4_i1600" with lines 
FFF  
	echo "the pic have done,named test.png"  
	exit 0  
