# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..2\n"; }
END {print "not ok 1\n" unless $loaded;}
use Tie::TextDir;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

sub report_result {
	$TEST_NUM ||= 2;
	print ( $_[0] ? "ok $TEST_NUM\n" : "not ok $TEST_NUM\n" );
	$TEST_NUM++;
}

# 1: store and recall
{
	my ($ok, $dir, $val) = (1, '/tmp/TextDir_test', "one line\ntwo lines\nbad stuff\003\005\n");
	
	tie (%hash, 'Tie::TextDir', $dir, 'rw') or do {$ok = 0};
	$hash{'file'} = $val;
	untie %hash;
	
	tie (%hash, 'Tie::TextDir', $dir) or do {$ok = 0};
	$hash{'file'} eq $val or do {$ok = 0};
	&report_result($ok);
	unlink "$dir/file";
	rmdir $dir;
}