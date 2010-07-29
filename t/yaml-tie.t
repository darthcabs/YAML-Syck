use strict;
use Test::More tests => 6;
use YAML::Syck;
use Tie::Hash;

{
    my %h;
    my $rh = \%h;
    %h = (a=>1, b=>'2', c=>3.1415, d=>4);
    bless $rh => 'Tie::StdHash';

    is(Dump($rh), "--- !!perl/hash:Tie::StdHash \na: 1\nb: 2\nc: '3.1415'\nd: 4\n");
    is(Dump(\%h), "--- !!perl/hash:Tie::StdHash \na: 1\nb: 2\nc: '3.1415'\nd: 4\n");
}
{
    my %h;
    my $th = tie %h, 'Tie::StdHash';
    %h = (a=>1, b=>'2', c=>3.1415, d=>4);

    SKIP: {
	skip "Perl 5.8.[67] seem to have issues with large ints as ints", 1 unless($] >= '5.008008' || $] < '5.007');
	is(Dump($th), "--- !!perl/hash:Tie::StdHash \na: 1\nb: 2\nc: '3.1415'\nd: 4\n");
    }

    TODO: {
        local $TODO = "Tied hashes don't dump"; 
        is(Dump(\%h), "--- !!perl/hash:Tie::StdHash \na: 1\nb: 2\nc: '3.1415'\nd: 4\n");
    }
}

{
    my %h;
    my $th = tie %h, 'Tie::StdHash';
    $h{a} = 1;
    $h{b} = '2';
    $h{c} = 3.1415;
    $h{d} = 4;

    is(Dump($th), "--- !!perl/hash:Tie::StdHash \na: 1\nb: 2\nc: '3.1415'\nd: 4\n");
    TODO: {
        local $TODO = "Tied hashes don't dump"; 
        is(Dump(\%h), "--- !!perl/hash:Tie::StdHash \na: 1\nb: 2\nc: '3.1415'\nd: 4\n");
    }
}
