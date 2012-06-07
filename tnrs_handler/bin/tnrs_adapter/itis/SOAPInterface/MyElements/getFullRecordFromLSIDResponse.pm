
package MyElements::getFullRecordFromLSIDResponse;
use strict;
use warnings;

{ # BLOCK to scope variables

sub get_xmlns { 'http://itis_service.itis.usgs.org' }

__PACKAGE__->__set_name('getFullRecordFromLSIDResponse');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref();

use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %return_of :ATTR(:get<return>);

__PACKAGE__->_factory(
    [ qw(        return

    ) ],
    {
        'return' => \%return_of,
    },
    {
        'return' => 'MyTypes::SvcFullRecord',
    },
    {

        'return' => 'return',
    }
);

} # end BLOCK






} # end of BLOCK



1;


=pod

=head1 NAME

MyElements::getFullRecordFromLSIDResponse

=head1 DESCRIPTION

Perl data type class for the XML Schema defined element
getFullRecordFromLSIDResponse from the namespace http://itis_service.itis.usgs.org.







=head1 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * return

 $element->set_return($data);
 $element->get_return();





=back


=head1 METHODS

=head2 new

 my $element = MyElements::getFullRecordFromLSIDResponse->new($data);

Constructor. The following data structure may be passed to new():

 {
   return =>  { # MyTypes::SvcFullRecord
     acceptedNameList =>  { # MyTypes::SvcAcceptedNameList
       acceptedNames =>  { # MyTypes::SvcAcceptedName
         acceptedName =>  $some_value, # string
         acceptedTsn =>  $some_value, # string
       },
     },
     commentList =>  { # MyTypes::SvcTaxonCommentList
       comments =>  { # MyTypes::SvcTaxonComment
         commentDetail =>  $some_value, # string
         commentId =>  $some_value, # string
         commentTimeStamp =>  $some_value, # string
         commentator =>  $some_value, # string
         updateDate =>  $some_value, # string
       },
     },
     commonNameList =>  { # MyTypes::SvcCommonNameList
       commonNames =>  { # MyTypes::SvcCommonName
         commonName =>  $some_value, # string
         language =>  $some_value, # string
         tsn =>  $some_value, # string
       },
     },
     completenessRating =>  { # MyTypes::SvcGlobalSpeciesCompleteness
       completeness =>  $some_value, # string
       rankId =>  $some_value, # int
     },
     coreMetadata =>  { # MyTypes::SvcCoreMetadata
       credRating =>  $some_value, # string
       rankId =>  $some_value, # int
       taxonCoverage =>  $some_value, # string
       taxonCurrency =>  $some_value, # string
       taxonUsageRating =>  $some_value, # string
       unacceptReason =>  $some_value, # string
     },
     credibilityRating =>  { # MyTypes::SvcCredibilityData
       credRating =>  $some_value, # string
     },
     currencyRating =>  { # MyTypes::SvcCurrencyData
       rankId =>  $some_value, # int
       taxonCurrency =>  $some_value, # string
     },
     dateData =>  { # MyTypes::SvcTaxonDateData
       initialTimeStamp =>  $some_value, # string
       updateDate =>  $some_value, # string
     },
     expertList =>  { # MyTypes::SvcTaxonExpertList
       experts =>  { # MyTypes::SvcTaxonExpert
         comment =>  $some_value, # string
         expert =>  $some_value, # string
         referenceFor =>  { # MyTypes::SvcReferenceForElement
           name =>  $some_value, # string
           refLanguage =>  $some_value, # string
           referredTsn =>  $some_value, # string
         },
         updateDate =>  $some_value, # string
       },
     },
     geographicDivisionList =>  { # MyTypes::SvcTaxonGeoDivisionList
       geoDivisions =>  { # MyTypes::SvcTaxonGeoDivision
         geographicValue =>  $some_value, # string
         updateDate =>  $some_value, # string
       },
     },
     hierarchyUp =>  { # MyTypes::SvcHierarchyRecord
       parentName =>  $some_value, # string
       parentTsn =>  $some_value, # string
       rankName =>  $some_value, # string
       taxonName =>  $some_value, # string
     },
     jurisdictionalOriginList =>  { # MyTypes::SvcTaxonJurisdictionalOriginList
       jurisdictionalOrigins =>  { # MyTypes::SvcTaxonJurisdictionalOrigin
         jurisdictionValue =>  $some_value, # string
         origin =>  $some_value, # string
         updateDate =>  $some_value, # string
       },
     },
     kingdom =>  { # MyTypes::SvcKingdomInfo
       kingdomId =>  $some_value, # string
       kingdomName =>  $some_value, # string
     },
     otherSourceList =>  { # MyTypes::SvcTaxonOtherSourceList
       otherSources =>  { # MyTypes::SvcTaxonOtherSource
         acquisitionDate =>  $some_value, # string
         referenceFor =>  { # MyTypes::SvcReferenceForElement
           name =>  $some_value, # string
           refLanguage =>  $some_value, # string
           referredTsn =>  $some_value, # string
         },
         source =>  $some_value, # string
         sourceComment =>  $some_value, # string
         sourceType =>  $some_value, # string
         updateDate =>  $some_value, # string
         version =>  $some_value, # string
       },
     },
     parentTSN =>  { # MyTypes::SvcParentTsn
       parentTsn =>  $some_value, # string
     },
     publicationList =>  { # MyTypes::SvcTaxonPublicationList
       publications =>  { # MyTypes::SvcTaxonPublication
         actualPubDate =>  $some_value, # string
         isbn =>  $some_value, # string
         issn =>  $some_value, # string
         listedPubDate =>  $some_value, # string
         pages =>  $some_value, # string
         pubComment =>  $some_value, # string
         pubName =>  $some_value, # string
         pubPlace =>  $some_value, # string
         publisher =>  $some_value, # string
         referenceAuthor =>  $some_value, # string
         referenceFor =>  { # MyTypes::SvcReferenceForElement
           name =>  $some_value, # string
           refLanguage =>  $some_value, # string
           referredTsn =>  $some_value, # string
         },
         title =>  $some_value, # string
         updateDate =>  $some_value, # string
       },
     },
     scientificName =>  { # MyTypes::SvcScientificName
       combinedName =>  $some_value, # string
       unitInd1 =>  $some_value, # string
       unitInd2 =>  $some_value, # string
       unitInd3 =>  $some_value, # string
       unitInd4 =>  $some_value, # string
       unitName1 =>  $some_value, # string
       unitName2 =>  $some_value, # string
       unitName3 =>  $some_value, # string
       unitName4 =>  $some_value, # string
     },
     synonymList =>  { # MyTypes::SvcSynonymNameList
       synonyms =>  { # MyTypes::SvcTaxonName
         name =>  $some_value, # string
         tsn =>  $some_value, # string
       },
     },
     taxRank =>  { # MyTypes::SvcTaxonRankInfo
       kingdomId =>  $some_value, # string
       kingdomName =>  $some_value, # string
       rankId =>  $some_value, # string
       rankName =>  $some_value, # string
     },
     taxonAuthor =>  { # MyTypes::SvcTaxonAuthorship
       authorship =>  $some_value, # string
       updateDate =>  $some_value, # string
     },
     unacceptReason =>  { # MyTypes::SvcUnacceptData
       unacceptReason =>  $some_value, # string
     },
     usage =>  { # MyTypes::SvcTaxonUsageData
       taxonUsageRating =>  $some_value, # string
     },
   },
 },

=head1 AUTHOR

Generated by SOAP::WSDL

=cut

