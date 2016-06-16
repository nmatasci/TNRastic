package MyTypes::SvcCurrencyData;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'http://data.itis_service.itis.usgs.org/xsd' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}


use base qw(MyTypes::SvcTaxonomicBase);
# Variety: sequence
use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %tsn_of :ATTR(:get<tsn>);
my %rankId_of :ATTR(:get<rankId>);
my %taxonCurrency_of :ATTR(:get<taxonCurrency>);

__PACKAGE__->_factory(
    [ qw(        tsn
        rankId
        taxonCurrency

    ) ],
    {
        'tsn' => \%tsn_of,
        'rankId' => \%rankId_of,
        'taxonCurrency' => \%taxonCurrency_of,
    },
    {
        'tsn' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'rankId' => 'SOAP::WSDL::XSD::Typelib::Builtin::int',
        'taxonCurrency' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
    },
    {

        'tsn' => 'tsn',
        'rankId' => 'rankId',
        'taxonCurrency' => 'taxonCurrency',
    }
);

} # end BLOCK







1;


=pod

=head1 NAME

MyTypes::SvcCurrencyData

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
SvcCurrencyData from the namespace http://data.itis_service.itis.usgs.org/xsd.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * rankId


=item * taxonCurrency




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # MyTypes::SvcCurrencyData
   rankId =>  $some_value, # int
   taxonCurrency =>  $some_value, # string
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

