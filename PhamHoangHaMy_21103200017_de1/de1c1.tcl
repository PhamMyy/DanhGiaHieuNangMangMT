# Simulation parameters setup
set val(stop) 12.0 ;# time of simulation end

# Initialization
set ns [new Simulator]

# Open the NS trace file
set tracefile [open output.tr w]
$ns trace-all $tracefile

# Open the NAM trace file
set namfile [open output.nam w]
$ns namtrace-all $namfile

# Nodes Definition
# Create network nodes
set s0 [$ns node]
set s1 [$ns node]
set s2 [$ns node]
set r1 [$ns node]
set r2 [$ns node]
set r3 [$ns node]
set s6 [$ns node]
set s7 [$ns node]
set s8 [$ns node]

# Links Definition
# Create duplex links between nodes with given bandwidth and delay
$ns duplex-link $s0 $r1 10Mb 5ms DropTail
$ns duplex-link $s1 $r1 10Mb 5ms DropTail
$ns duplex-link $s2 $r1 10Mb 5ms DropTail
$ns duplex-link $r1 $r2 1.5Mb 15ms DropTail
$ns duplex-link $r2 $r3 1.5Mb 15ms DropTail
$ns duplex-link $r3 $s6 10Mb 5ms DropTail
$ns duplex-link $r3 $s7 10Mb 5ms DropTail
$ns duplex-link $r3 $s8 10Mb 5ms DropTail
$ns queue-limit $r1 $r2 50

# Agents Definition
# Define TCP agents and their sinks
set tcp0 [new Agent/TCP]
$tcp0 set window_ 32
$ns attach-agent $s0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $s6 $sink0
$ns connect $tcp0 $sink0

set tcp1 [new Agent/TCP]
$tcp1 set window_ 64
$ns attach-agent $s1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $s7 $sink1
$ns connect $tcp1 $sink1

set tcp2 [new Agent/TCP]
$tcp2 set window_ 16
$ns attach-agent $s2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $s8 $sink2
$ns connect $tcp2 $sink2

# Define UDP agents and sinks
set udp0 [new Agent/UDP]
$ns attach-agent $r3 $udp0
set null0 [new Agent/Null]
$ns attach-agent $s6 $null0
$ns connect $udp0 $null0

# Applications Definition
# FTP Applications over TCP
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 0.4 "$ftp0 start"
$ns at 10.4 "$ftp0 stop"

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 0.6 "$ftp1 start"
$ns at 10.6 "$ftp1 stop"

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 0.8 "$ftp2 start"
$ns at 10.8 "$ftp2 stop"

# CBR Application over UDP
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1.5Mb
$cbr0 set random_ 0
$ns at 7.0 "$cbr0 start"
$ns at 8.0 "$cbr0 stop"

# Termination
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam output.nam &
    exit 0
}

$ns at $val(stop) "finish"
$ns run
