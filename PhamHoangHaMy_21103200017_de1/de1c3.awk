BEGIN {
    total_delay = 0       # Tổng độ trễ
    packet_count = 0      # Tổng số gói tin
    start_time = 0        # Thời gian bắt đầu
    OFS = "\t"            # Ký tự phân tách khi in
}

{
    # Chỉ xử lý gói tin nhận (r) và giao thức TCP/UDP
    if ($1 == "r" && ($5 == "tcp" || $5 == "udp")) {
        delay = $2 - $9  # Độ trễ = thời gian nhận - thời gian gửi
        
        # Đặt thời gian bắt đầu khi nhận gói tin đầu tiên
        if (packet_count == 0) {
            start_time = $2
        }
        
        # Cập nhật tổng độ trễ và số gói tin
        total_delay += delay
        packet_count++

        # Tính độ trễ trung bình
        avg_delay = total_delay / packet_count

        # Tính jitter
        jitter = delay - avg_delay

        # In ra kết quả
        printf("Time: %f%sDelay: %f%sAvg_Delay: %f%sJitter: %f\n", 
               $2, OFS, delay, OFS, avg_delay, OFS, jitter)
    }
}

END {
    print "Simulation complete."
}
