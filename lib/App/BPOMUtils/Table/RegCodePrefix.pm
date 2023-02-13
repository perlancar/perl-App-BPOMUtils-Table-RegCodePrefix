package App::BPOMUtils::Table::RegCodePrefix;

use 5.010001;
use strict 'subs', 'vars';
use utf8;
use warnings;
use Log::ger;

use Exporter 'import';
use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(
                       bpom_list_reg_code_prefixes
               );

our %SPEC;

our $meta_reg_code_prefixes = {
  summary => "Known alphabetical prefixes in BPOM registered product codes",
  "fields" => {
    code => {
      pos => 0,
      schema => ["str*"],
      sortable => 1,
      summary => "code",
    },
    division => {
      pos      => 1,
      schema   => ["str*"],
      sortable => 1,
      summary  => "Division (food, supplement [including herbal], medicine)",
      unique   => 0,
    },
    summary_eng => {
      pos      => 2,
      schema   => ["str*"],
      sortable => 1,
      summary  => "Summary (in English)",
      unique   => 0,
    },
    summary_ind => {
      pos      => 3,
      schema   => ["str*"],
      sortable => 1,
      summary  => "Summary (in Indonesian)",
      unique   => 0,
    },
  },
  "pk" => "code",
  "summary" => "BPOM registered product code prefixes",
  "summary.alt.lang.id_ID" => "Awalan huruf di kode produk terdaftar BPOM",
};

our $data_reg_code_prefixes = [
    ["MD", "food", "Food (local)", "Makanan (dalam negeri)"],
    ["ML", "food", "Food (imported)", "Makanan (impor)"],


    # ?N? and ?P? codes currently are not listed here

    ["DBL", "medicine", "Local (L) OTC (B) patented (D) medicine", "Obat paten (D) bebas (B) lokal (L)"],
    ["DBI", "medicine", "Imported (L) OTC (B) patented (D) medicine", "Obat paten (D) bebas (B) impor (I)"],
    ["DBE", "medicine", "Exported (L) OTC (B) patented (D) medicine", "Obat paten (D) bebas (B) ekspor (E)"],
    ["DBX", "medicine", "Special-purpose (X) OTC (B) patented (D) medicine", "Obat paten (D) bebas (B) keperluan khusus (X)"],

    ["DTL", "medicine", "Local (L) limited-OTC (T) patented (D) medicine", "Obat paten (D) bebas terbatas (T) lokal (L)"],
    ["DTI", "medicine", "Imported (L) limited-OTC (T) patented (D) medicine", "Obat paten (D) bebas terbatas (T) impor (I)"],
    ["DTE", "medicine", "Exported (L) limited-OTC (T) patented (D) medicine", "Obat paten (D) bebas terbatas (T) ekspor (E)"],
    ["DTX", "medicine", "Special-purpose (X) limited-OTC (T) patented (D) medicine", "Obat paten (D) bebas terbatas (T) keperluan khusus (X)"],

    ["DKL", "medicine", "Local (L) hard (K) patented (D) medicine", "Obat paten (D) keras (K) lokal (L)"],
    ["DKI", "medicine", "Imported (L) hard (K) patented (D) medicine", "Obat paten (D) keras (K) impor (I)"],
    ["DKE", "medicine", "Exported (L) hard (K) patented (D) medicine", "Obat paten (D) keras (K) ekspor (E)"],
    ["DKX", "medicine", "Special-purpose (X) hard (K) patented (D) medicine", "Obat paten (D) keras (K) keperluan khusus (X)"],

    ["GBL", "medicine", "Local (L) OTC (B) generic (G) medicine", "Obat generik (G) bebas (B) lokal (L)"],
    ["GBI", "medicine", "Imported (L) OTC (B) generic (G) medicine", "Obat generik (G) bebas (B) impor (I)"],
    ["GBE", "medicine", "Exported (L) OTC (B) generic (G) medicine", "Obat generik (G) bebas (B) ekspor (E)"],
    ["GBX", "medicine", "Special-purpose (X) OTC (B) generic (G) medicine", "Obat generik (G) bebas (B) keperluan khusus (X)"],

    ["GTL", "medicine", "Local (L) limited-OTC (T) generic (G) medicine", "Obat generik (G) bebas terbatas (T) lokal (L)"],
    ["GTI", "medicine", "Imported (L) limited-OTC (T) generic (G) medicine", "Obat generik (G) bebas terbatas (T) impor (I)"],
    ["GTE", "medicine", "Exported (L) limited-OTC (T) generic (G) medicine", "Obat generik (G) bebas terbatas (T) ekspor (E)"],
    ["GTX", "medicine", "Special-purpose (X) limited-OTC (T) generic (G) medicine", "Obat generik (G) bebas terbatas (T) keperluan khusus (X)"],

    ["GKL", "medicine", "Local (L) hard (K) generic (G) medicine", "Obat generik (G) keras (K) lokal (L)"],
    ["GKI", "medicine", "Imported (L) hard (K) generic (G) medicine", "Obat generik (G) keras (K) impor (I)"],
    ["GKE", "medicine", "Exported (L) hard (K) generic (G) medicine", "Obat generik (G) keras (K) ekspor (E)"],
    ["GKX", "medicine", "Special-purpose (X) hard (K) generic (G) medicine", "Obat generik (G) keras (K) keperluan khusus (X)"],


    ["SD", "supplement+cosmetic", "Local supplement", "Suplemen dalam negeri"],
    ["SI", "supplement+cosmetic", "Imported supplement", "Suplemen impor"],
    ["SL", "supplement+cosmetic", "Licensed Supplement", "Suplemen dalam negeri dengan lisensi"],

    ["BTR", "supplement+cosmetic", "Local traditional medicine/production medicine", "Obat tradisional berbatasan dengan obat produksi, dalam negeri"],
    ["BTI", "supplement+cosmetic", "Imported traditional medicine/production medicine", "Obat tradisional berbatasan dengan obat produksi, impor"],
    ["BTL", "supplement+cosmetic", "Licensed traditional medicine/production medicine", "Obat tradisional berbatasan dengan obat produksi, dalam negeri dengan lisensi"],

    ["NA", "supplement+cosmetic", "Cosmetics from Asia including local", "Kosmetik dari Asia termasuk lokal"],
    ["NB", "supplement+cosmetic", "Cosmetics from Australia", "Kosmetik dari Australia"],
    ["NC", "supplement+cosmetic", "Cosmetics from Europe", "Kosmetik dari Eropa"],
    ["ND", "supplement+cosmetic", "Cosmetics from Africa", "Kosmetik dari Afrika"],
    ["NE", "supplement+cosmetic", "Cosmetics from America", "Kosmetik dari Amerika"],
];

my $res = gen_read_table_func(
    name => 'bpom_list_reg_code_prefixes',
    summary => 'List known alphabetical prefixes in BPOM registered product codes',
    table_data => $data_reg_code_prefixes,
    table_spec => $meta_reg_code_prefixes,
    description => <<'_',
_
    extra_props => {
        examples => [
        ],
    },
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
# ABSTRACT:

=head1 DESCRIPTION

This distribution contains the following CLIs:

# INSERT_EXECS_LIST
