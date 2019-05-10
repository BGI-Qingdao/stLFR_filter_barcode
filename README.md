# stLFR_filter_barcode

This is a tool suit to filter " not so good " barcodes from stLFR reads.

The " not so good " barcodes refer to those who contain "too few" or "too many " read pairs.

## Usage 

### threshold_calc.sh

threshold_calc is used to calculate the two threshold that define "too few" and "too many ".

Used it like :

```
% threshold_calc.sh your-barcode-freq.txt your-genome-size(in bp)  your-expect-cov
```

Example :

```
% ./threshold_calc.sh test_data/barcode.freq 1000 50 
INFO : run with BarcodeFreq=test_data/barcode.freq GenomeSize=1000 ExpectCov=50 
INFO : expect reads_pair=250
INFO : total reads_pair=9176
INFO : delete barcode with too many reads : big_pair=26
RESULT : high threshold is 500 and low threshold is 2
RESULT : delete 26 from barcodes that contain reads-pair > 500.
RESULT : delete 9150 from barcodes that contain reads-pair < 2.
RESULT : left 50000 reads = 50 cov
Done ...
```

###  filter_barcode.pl

As threshold is known, it's time to filter the reads with threshold.

Use it like :
```
filter_barcode.pl r1.gz r2.gz barcode.freq min max
```
Example :

```
../filter_barcode.pl  reads.1.fq.gz reads.2.fq.gz barcode.freq 2 2
filter barcode !
    read1 :  reads.1.fq.gz 
    read2 : reads.2.fq.gz 
    barcode_freq : barcode.freq 
    min_freq: 2 , max_freq : 2

```
*Notice : the output file is your-input-file-name + ".filter.fq.gz"*

Enjoy it !!!
