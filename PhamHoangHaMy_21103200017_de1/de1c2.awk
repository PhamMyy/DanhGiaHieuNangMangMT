
BEGIN {
    # Initialize data structures and variables
    for (i in sent_pkt) {
        sent_pkt[i] = 0
    }
    
    total_delay_ftp0 = 0
    total_delay_ftp1 = 0
    total_delay_ftp2 = 0
    num_pkt_ftp0 = 0
    num_pkt_ftp1 = 0
    num_pkt_ftp2 = 0
    data_ftp0 = 0
    data_ftp1 = 0
    data_ftp2 = 0
}

{
    # Event: Packet sent (TCP only)
    if ($1 == "-" && $5 == "tcp") {
        # Track packets sent by each FTP flow (identified by flow ID)
        if ($3 == "0") { sent_pkt[$12] = $2 }  # Flow 0 (FTP0)
        if ($3 == "1") { sent_pkt[$12] = $2 }  # Flow 1 (FTP1)
        if ($3 == "2") { sent_pkt[$12] = $2 }  # Flow 2 (FTP2)
    }
    
    # Event: Packet received (TCP only)
    if ($1 == "r" && $5 == "tcp") {
        if ($4 == "6") {  # S6: FTP0 received
            data_ftp0 += $6
            if (sent_pkt[$12] > 0) {
                total_delay_ftp0 += $2 - sent_pkt[$12]
                num_pkt_ftp0++
            }
        }
        if ($4 == "8") {  # S8: FTP1 received
            data_ftp1 += $6
            if (sent_pkt[$12] > 0) {
                total_delay_ftp1 += $2 - sent_pkt[$12]
                num_pkt_ftp1++
            }
        }
        if ($4 == "7") {  # S7: FTP2 received
            data_ftp2 += $6
            if (sent_pkt[$12] > 0) {
                total_delay_ftp2 += $2 - sent_pkt[$12]
                num_pkt_ftp2++
            }
        }
    }
}

END {
    # Calculate and print throughput and delay for each FTP flow
    printf("Thong luong FTP0 trung binh = %f Mbps\n", data_ftp0 * 8 / (10.0 * 1024 * 1024));
    printf("Thong luong FTP1 trung binh = %f Mbps\n", data_ftp1 * 8 / (10.0 * 1024 * 1024));
    printf("Thong luong FTP2 trung binh = %f Mbps\n", data_ftp2 * 8 / (10.0 * 1024 * 1024));
    
    printf("Do tre FTP0 trung binh = %f s\n", total_delay_ftp0 / num_pkt_ftp0);
    printf("Do tre FTP1 trung binh = %f s\n", total_delay_ftp1 / num_pkt_ftp1);
    printf("Do tre FTP2 trung binh = %f s\n", total_delay_ftp2 / num_pkt_ftp2);
}


