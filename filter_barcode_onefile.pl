#!/usr/bin/perl

if ( $#ARGV != 3 )
{
    print "Usage : merge_barcode.pl r1.gz barcode.freq min max\n";
    exit(1);
}

print "filter barcode !\
    read :  $ARGV[0] \
    barcode_freq : $ARGV[1] \
    min_freq: $ARGV[2] , max_freq : $ARGV[3]\n";

open IN_bf ," < $ARGV[1] " or die "failed to open $ARGV[1] for read";
while(<IN_bf>)
{
    chomp;
    my @pair =split(/\t/,$_);
    $map{$pair[0]}=$pair[1] ;
}
close(IN_bf);
$map{"0_0_0"}="-1000";

$r1=$ARGV[0];
$r1_f="$r1".".filter.fq.gz";
$min=$ARGV[2];
$max=$ARGV[3];

open IN_r1 ,  "gzip -dc $r1 | " or die "failed to open $r1 for read !!";
open OUT_r1 , "| gzip >$r1_f" or die "failed to write $r1_f";
$line_num=0;

while(<IN_r1>)
{
    $line_num++;
    if (  $line_num %4000000 == 0)
    {
        $Mr= int($line_num / 4000000);
        print "process read1 $Mr (Mb) pair of reads now  \n";
        $|=1;
    }
    chomp;
    # head looks like : @CL200051332L1C001R001_0#1335_550_1232/2        1       1
    my @line=split(/\t/, $_);
    my @name1=split(/\#/, $line[0]);
    my @name=split(/\//, $name1[1]);

    if(  $map{$name[0]} >= $min and  $map{$name[0]} <= $max )
    {
        $S2=<IN_r1>;
        $S3=<IN_r1>;
        $S4=<IN_r1>;
        print OUT_r1 $_."\n";
        print OUT_r1 $S2;
        print OUT_r1 $S3;
        print OUT_r1 $S4;
    }
    else
    {
        $S2=<IN_r1>;
        $S3=<IN_r1>;
        $S4=<IN_r1>;
        next;
    }
}
close(IN_r1);
close(OUT_r1);

