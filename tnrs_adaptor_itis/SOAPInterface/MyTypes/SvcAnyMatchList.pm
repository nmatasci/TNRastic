package MyTypes::SvcAnyMatchList;
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

my %anyMatchList_of :ATTR(:get<anyMatchList>);

__PACKAGE__->_factory(
    [ qw(        anyMatchList

    ) ],
    {
        'anyMatchList' => \%anyMatchList_of,
    },
    {
        'anyMatchList' => 'MyTypes::SvcAnyMatch',
    },
    {

        'anyMatchList' => 'anyMatchList',
    }
);

} # end BLOCK







1;


=pod

=head1 NAME

MyTypes::SvcAnyMatchList

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
SvcAnyMatchList from the namespace http://data.itis_service.itis.usgs.org/xsd.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * anyMatchList




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # MyTypes::SvcAnyMatchList
   anyMatchList =>  { # MyTypes::SvcAnyMatch
     commonNameList =>  { # MyTypes::SvcCommonNameList
       commonNames =>  { # MyTypes::SvcCommonName
         commonName =>  $some_value, # string
         language =>  $some_value, # string
         tsn =>  $some_value, # string
       },
     },
     matchType =>  $some_value, # string
     sciName =>  $some_value, # string
     tsn =>  $some_value, # string
   },
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

