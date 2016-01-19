use v6;
use NativeCall;
use LibraryMake;
use Crypt::TweetNacl::Constants;

unit module Crypt::TweetNacl::Basics;


sub remove_leading_elems($return_type!, $buf!, Int $num_elems) is export
{
    my $data := $return_type.new;
    my $dlen = $buf.elems - $num_elems;
    $data[$dlen - 1] = 0;
    my $i = 0;
    loop ($i = 0; $i < $dlen; $i++)
    {
        $data[$i] = $buf[$i + $num_elems];
    }
    return $data;
}




# void randombytes(unsigned char *x,unsigned long long xlen)

# todo check signedness of xlen
sub randombytes_int(CArray[int8], ulonglong) is symbol('randombytes') is native(TWEETNACL) is export { * }

sub randombytes(int $xlen!) is export
{
    my $data = CArray[int8].new;
    $data[$xlen - 1] = 0;
    randombytes_int($data, $xlen);
    return $data;
}

sub nonce() is export
{
    return randombytes(CRYPTO_BOX_NONCEBYTES);
}


sub prepend_zeros($buf!, Int $num_zeros!) is export
{
    my $mlen = $num_zeros + $buf.elems;
    my $msg  = CArray[int8].new;
    $msg[$mlen - 1] = 0;        #alloc
    my Int $i;
    loop ($i=0; $i < $num_zeros ; $i++)
    {
        $msg[$i] = 0;
    }
    loop ($i=0; $i < $buf.elems; ++$i)
    {
        $msg[$i+$num_zeros] = $buf[$i];
    }
    return $msg;
}