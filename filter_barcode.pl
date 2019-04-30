#!/usr/bin/perl

if ( $#ARGV != 4 )
{
    print "Usage : merge_barcode.pl r1.gz r2.gz barcode.freq min max\n";
    exit(1);
}

print "filter barcode !\
    read1 :  $ARGV[0] \
    read2 : $ARGV[1] \
    barcode_freq : $ARGV[2] \
    min_freq: $ARGV[3] , max_freq : $ARGV[4]\n";

open IN_bf ," < $ARGV[2] " or die "failed to open $ARGV[2] for read";
while(<IN_bf>)
{
    chomp;
    my @pair =split(/\t/,$_);
    $map{$pair[0]}=$pair[1] ;
}
close(IN_bf);
$map{"0_0_0"}="-1000";

$r1=$ARGV[0];
$r1_f="$r1".".filter.gz";
$r2=$ARGV[1];
$r2_f="$r2".".filter.gz";
$min=$ARGV[3];
$max=$ARGV[4];

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

open IN_r2 ,  "gzip -dc $r1 | " or die "failed to open $r1 for read !!";
open OUT_r2 , "| gzip >$r2_f" or die "failed to write $r1_f";
$line_num=0;

while(<IN_r2>)
{
    $line_num++;
    if (  $line_num %4000000 == 0)
    {
        $Mr= int($line_num / 4000000);
        print "process read2 $Mr (Mb) pair of reads now  \n";
        $|=1;
    }
    chomp;
    # head looks like : @CL200051332L1C001R001_0#1335_550_1232/2        1       1
    my @line=split(/\t/, $_);
    my @name1=split(/\#/, $line[0]);
    my @name=split(/\//, $name1[1]);

    if(  $map{$name[0]} >= $min &&  $map{$name[0]} <= $max )
    {
        $S2=<IN_r2>;
        $S3=<IN_r2>;
        $S4=<IN_r2>;
        print OUT_r2 $_."\n";
        print OUT_r2 $S2;
        print OUT_r2 $S3;
        print OUT_r2 $S4;
    }
    else
    {
        $S2=<IN_r2>;
        $S3=<IN_r2>;
        $S4=<IN_r2>;
    }
}
close(IN_r2);
close(OUT_r2);
