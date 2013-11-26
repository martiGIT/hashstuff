#!/usr/bin/perl
# Rainbow table generator by Marcin Rybak <marcin.rybak@gmail.com>
#
# This scrips loads dictionary from file dict.txt and calculates MD5, SHA1, 
# SHA256 and SHA512 hashes, and insert it to mysql database 

use Digest::MD5  qw(md5 md5_hex md5_base64);
use Digest::SHA  qw(sha1_hex sha256_hex sha512_hex);
use DBI;

#configure your database bellow
my $dbh = DBI->connect('DBI:mysql:db_name:localhost', 'db_user', 'db_pass') || die "Could not connect $DBI::errstr";

# modify bellow if you would like to change file with dictionary
open (FILE, 'dict.txt') || die('Could not open file');
while (<FILE>) {
        my $data;
        chomp($data = $_);
        $data =~ s/\r\n?//g;
        $hashmd5 = md5_hex $data;
	$hashsha1 = sha1_hex $data;
	$hashsha256 = sha256_hex $data;
	$hashsha512 = sha512_hex $data;
        $data =~ s/'/''/g;
        my @vals = ($data, $hashmd5, $hashsha1,$hashsha256,$hashsha512);
        my $sth = $dbh->prepare("insert into tablename (word, hashmd5, hashsha1, hashsha256, hashsha512) values (?,?,?,?,?)");
        $sth->execute(@vals) || die "Query failed! $DBI::errstr";
}
close(FILE);
$dbh->disconnect();
