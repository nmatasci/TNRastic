package MyTypes::SvcFullRecord;
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
my %acceptedNameList_of :ATTR(:get<acceptedNameList>);
my %commentList_of :ATTR(:get<commentList>);
my %commonNameList_of :ATTR(:get<commonNameList>);
my %completenessRating_of :ATTR(:get<completenessRating>);
my %coreMetadata_of :ATTR(:get<coreMetadata>);
my %credibilityRating_of :ATTR(:get<credibilityRating>);
my %currencyRating_of :ATTR(:get<currencyRating>);
my %dateData_of :ATTR(:get<dateData>);
my %expertList_of :ATTR(:get<expertList>);
my %geographicDivisionList_of :ATTR(:get<geographicDivisionList>);
my %hierarchyUp_of :ATTR(:get<hierarchyUp>);
my %jurisdictionalOriginList_of :ATTR(:get<jurisdictionalOriginList>);
my %kingdom_of :ATTR(:get<kingdom>);
my %otherSourceList_of :ATTR(:get<otherSourceList>);
my %parentTSN_of :ATTR(:get<parentTSN>);
my %publicationList_of :ATTR(:get<publicationList>);
my %scientificName_of :ATTR(:get<scientificName>);
my %synonymList_of :ATTR(:get<synonymList>);
my %taxRank_of :ATTR(:get<taxRank>);
my %taxonAuthor_of :ATTR(:get<taxonAuthor>);
my %unacceptReason_of :ATTR(:get<unacceptReason>);
my %usage_of :ATTR(:get<usage>);

__PACKAGE__->_factory(
    [ qw(        tsn
        acceptedNameList
        commentList
        commonNameList
        completenessRating
        coreMetadata
        credibilityRating
        currencyRating
        dateData
        expertList
        geographicDivisionList
        hierarchyUp
        jurisdictionalOriginList
        kingdom
        otherSourceList
        parentTSN
        publicationList
        scientificName
        synonymList
        taxRank
        taxonAuthor
        unacceptReason
        usage

    ) ],
    {
        'tsn' => \%tsn_of,
        'acceptedNameList' => \%acceptedNameList_of,
        'commentList' => \%commentList_of,
        'commonNameList' => \%commonNameList_of,
        'completenessRating' => \%completenessRating_of,
        'coreMetadata' => \%coreMetadata_of,
        'credibilityRating' => \%credibilityRating_of,
        'currencyRating' => \%currencyRating_of,
        'dateData' => \%dateData_of,
        'expertList' => \%expertList_of,
        'geographicDivisionList' => \%geographicDivisionList_of,
        'hierarchyUp' => \%hierarchyUp_of,
        'jurisdictionalOriginList' => \%jurisdictionalOriginList_of,
        'kingdom' => \%kingdom_of,
        'otherSourceList' => \%otherSourceList_of,
        'parentTSN' => \%parentTSN_of,
        'publicationList' => \%publicationList_of,
        'scientificName' => \%scientificName_of,
        'synonymList' => \%synonymList_of,
        'taxRank' => \%taxRank_of,
        'taxonAuthor' => \%taxonAuthor_of,
        'unacceptReason' => \%unacceptReason_of,
        'usage' => \%usage_of,
    },
    {
        'tsn' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'acceptedNameList' => 'MyTypes::SvcAcceptedNameList',
        'commentList' => 'MyTypes::SvcTaxonCommentList',
        'commonNameList' => 'MyTypes::SvcCommonNameList',
        'completenessRating' => 'MyTypes::SvcGlobalSpeciesCompleteness',
        'coreMetadata' => 'MyTypes::SvcCoreMetadata',
        'credibilityRating' => 'MyTypes::SvcCredibilityData',
        'currencyRating' => 'MyTypes::SvcCurrencyData',
        'dateData' => 'MyTypes::SvcTaxonDateData',
        'expertList' => 'MyTypes::SvcTaxonExpertList',
        'geographicDivisionList' => 'MyTypes::SvcTaxonGeoDivisionList',
        'hierarchyUp' => 'MyTypes::SvcHierarchyRecord',
        'jurisdictionalOriginList' => 'MyTypes::SvcTaxonJurisdictionalOriginList',
        'kingdom' => 'MyTypes::SvcKingdomInfo',
        'otherSourceList' => 'MyTypes::SvcTaxonOtherSourceList',
        'parentTSN' => 'MyTypes::SvcParentTsn',
        'publicationList' => 'MyTypes::SvcTaxonPublicationList',
        'scientificName' => 'MyTypes::SvcScientificName',
        'synonymList' => 'MyTypes::SvcSynonymNameList',
        'taxRank' => 'MyTypes::SvcTaxonRankInfo',
        'taxonAuthor' => 'MyTypes::SvcTaxonAuthorship',
        'unacceptReason' => 'MyTypes::SvcUnacceptData',
        'usage' => 'MyTypes::SvcTaxonUsageData',
    },
    {

        'tsn' => 'tsn',
        'acceptedNameList' => 'acceptedNameList',
        'commentList' => 'commentList',
        'commonNameList' => 'commonNameList',
        'completenessRating' => 'completenessRating',
        'coreMetadata' => 'coreMetadata',
        'credibilityRating' => 'credibilityRating',
        'currencyRating' => 'currencyRating',
        'dateData' => 'dateData',
        'expertList' => 'expertList',
        'geographicDivisionList' => 'geographicDivisionList',
        'hierarchyUp' => 'hierarchyUp',
        'jurisdictionalOriginList' => 'jurisdictionalOriginList',
        'kingdom' => 'kingdom',
        'otherSourceList' => 'otherSourceList',
        'parentTSN' => 'parentTSN',
        'publicationList' => 'publicationList',
        'scientificName' => 'scientificName',
        'synonymList' => 'synonymList',
        'taxRank' => 'taxRank',
        'taxonAuthor' => 'taxonAuthor',
        'unacceptReason' => 'unacceptReason',
        'usage' => 'usage',
    }
);

} # end BLOCK







1;


=pod

=head1 NAME

MyTypes::SvcFullRecord

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
SvcFullRecord from the namespace http://data.itis_service.itis.usgs.org/xsd.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * acceptedNameList


=item * commentList


=item * commonNameList


=item * completenessRating


=item * coreMetadata


=item * credibilityRating


=item * currencyRating


=item * dateData


=item * expertList


=item * geographicDivisionList


=item * hierarchyUp


=item * jurisdictionalOriginList


=item * kingdom


=item * otherSourceList


=item * parentTSN


=item * publicationList


=item * scientificName


=item * synonymList


=item * taxRank


=item * taxonAuthor


=item * unacceptReason


=item * usage




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # MyTypes::SvcFullRecord
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




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

