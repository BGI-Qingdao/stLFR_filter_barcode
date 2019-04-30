#!/bin/bash

../filter_barcode.pl  reads.1.fq.gz reads.2.fq.gz barcode.freq 2 2 
gzip -dc reads.1.fq.gz.filter.fq.gz >tmp.1.filter
gzip -dc reads.2.fq.gz.filter.fq.gz >tmp.2.filter

diff reads.1.fq.gz.filter tmp.1.filter >diff_cache
diff reads.2.fq.gz.filter tmp.2.filter >>diff_cache

diff_info=`wc -l diff_cache`

if [[ "$diff_info" == "0 diff_cache" ]] ; then 
    echo "test pass !"
else 
    echo "\"$diff_info\""
    echo "test failed ! see diff_cache for more details." 
fi
