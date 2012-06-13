package MethodStandard;

use warnings ;
use strict ;

use Calcul;

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

# compute word weight for each language
sub words {
  my($file, $frequencies) = @_ ;
  my %hash_corpus ;

  # acquire frequencies in file corpus
  %hash_corpus = %{ Calcul::txt2hash($frequencies) };

  my $weight = 0 ;

  open(F, '<:utf8', $file);

  # if a word in file has a weight in the corpus, add it
  while (<F>) {
    my @words = split(/\pP|\pS|\s/, $_); # extract words
    for my $word(@words) {
      $weight += $hash_corpus{"$word"} if exists $hash_corpus{"$word"};
    }
  }

  close(F);
  return $weight;
}

# compute suffixes weight for each language
sub suffixes {
  my($file, $frequencies) = @_ ;
  my %hash_corpus ;
  my $weight = 0 ;

  %hash_corpus = %{ Calcul::txt2hash_suffix($frequencies) } ;

  open(F, '<:utf8', $file);

  # if a suffix in file has a weight in the corpus, add it
  while (<F>) {
    my @words = split(/\pP|\pS|\s/, $_); # extract words
    for my $word(@words) {
      for (my $n = 1 ; $n <= $main::gramm_number ; $n++) {
	my $tail = substr $word, -$n ;
	$weight += $hash_corpus{$tail} if (length($tail) == $n && exists $hash_corpus{$tail}); # avoid extra matches when word is shorter than gramm
      }
    }
  }
  close(F);
  return $weight;
}

1; # a perl module must return true value
