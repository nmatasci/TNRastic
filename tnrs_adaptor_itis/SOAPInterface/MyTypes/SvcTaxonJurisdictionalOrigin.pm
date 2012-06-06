package MyTypes::SvcTaxonJurisdictionalOrigin;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'http://data.itis_service.itis.usgs.org/xsd' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %jurisdictionValue_of :ATTR(:get<jurisdictionValue>);
my %origin_of :ATTR(:get<origin>);
my %updateDate_of :ATTR(:get<updateDate>);

__PACKAGE__->_factory(
    [ qw(        jurisdictionValue
        origin
        updateDate

    ) ],
    {
        'jurisdictionValue' => \%jurisdictionValue_of,
        'origin' => \%origin_of,
        'updateDate' => \%updateDate_of,
    },
    {
        'jurisdictionValue' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'origin' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'updateDate' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
    },
    {

        'jurisdictionValue' => 'jurisdictionValue',
        'origin' => 'origin',
        'updateDate' => 'updateDate',
    }
);

} # end BLOCK







1;


=pod

=head1 NAME

MyTypes::SvcTaxonJurisdictionalOrigin

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
SvcTaxonJurisdictionalOrigin from the namespace http://data.itis_service.itis.usgs.org/xsd.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * jurisdictionValue


=item * origin


=item * updateDate




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # MyTypes::SvcTaxonJurisdictionalOrigin
   jurisdictionValue =>  $some_value, # string
   origin =>  $some_value, # string
   updateDate =>  $some_value, # string
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

