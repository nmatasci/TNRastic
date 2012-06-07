package MyInterfaces::ITISService::ITISServiceHttpSoap11Endpoint;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use Scalar::Util qw(blessed);
use base qw(SOAP::WSDL::Client::Base);

# only load if it hasn't been loaded before
require MyTypemaps::ITISService
    if not MyTypemaps::ITISService->can('get_class');

sub START {
    $_[0]->set_proxy('http://www.itis.gov/ITISWebService/services/ITISService.ITISServiceHttpSoap11Endpoint/') if not $_[2]->{proxy};
    $_[0]->set_class_resolver('MyTypemaps::ITISService')
        if not $_[2]->{class_resolver};

    $_[0]->set_prefix($_[2]->{use_prefix}) if exists $_[2]->{use_prefix};
}

sub getReviewYearFromTSN {
    my ($self, $body, $header) = @_;
    die "getReviewYearFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getReviewYearFromTSN',
        soap_action => 'urn:getReviewYearFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getReviewYearFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getExpertsFromTSN {
    my ($self, $body, $header) = @_;
    die "getExpertsFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getExpertsFromTSN',
        soap_action => 'urn:getExpertsFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getExpertsFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub searchByCommonName {
    my ($self, $body, $header) = @_;
    die "searchByCommonName must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'searchByCommonName',
        soap_action => 'urn:searchByCommonName',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::searchByCommonName )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getVernacularLanguages {
    my ($self, $body, $header) = @_;
    die "getVernacularLanguages must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getVernacularLanguages',
        soap_action => 'urn:getVernacularLanguages',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getFullRecordFromLSID {
    my ($self, $body, $header) = @_;
    die "getFullRecordFromLSID must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getFullRecordFromLSID',
        soap_action => 'urn:getFullRecordFromLSID',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getFullRecordFromLSID )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getRecordFromLSID {
    my ($self, $body, $header) = @_;
    die "getRecordFromLSID must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getRecordFromLSID',
        soap_action => 'urn:getRecordFromLSID',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getRecordFromLSID )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getCoverageFromTSN {
    my ($self, $body, $header) = @_;
    die "getCoverageFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getCoverageFromTSN',
        soap_action => 'urn:getCoverageFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getCoverageFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getJurisdictionalOriginValues {
    my ($self, $body, $header) = @_;
    die "getJurisdictionalOriginValues must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getJurisdictionalOriginValues',
        soap_action => 'urn:getJurisdictionalOriginValues',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getTSNFromLSID {
    my ($self, $body, $header) = @_;
    die "getTSNFromLSID must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getTSNFromLSID',
        soap_action => 'urn:getTSNFromLSID',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getTSNFromLSID )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getCoreMetadataFromTSN {
    my ($self, $body, $header) = @_;
    die "getCoreMetadataFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getCoreMetadataFromTSN',
        soap_action => 'urn:getCoreMetadataFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getCoreMetadataFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getLastChangeDate {
    my ($self, $body, $header) = @_;
    die "getLastChangeDate must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getLastChangeDate',
        soap_action => 'urn:getLastChangeDate',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getParentTSNFromTSN {
    my ($self, $body, $header) = @_;
    die "getParentTSNFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getParentTSNFromTSN',
        soap_action => 'urn:getParentTSNFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getParentTSNFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getGeographicDivisionsFromTSN {
    my ($self, $body, $header) = @_;
    die "getGeographicDivisionsFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getGeographicDivisionsFromTSN',
        soap_action => 'urn:getGeographicDivisionsFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getGeographicDivisionsFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getTaxonomicRankNameFromTSN {
    my ($self, $body, $header) = @_;
    die "getTaxonomicRankNameFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getTaxonomicRankNameFromTSN',
        soap_action => 'urn:getTaxonomicRankNameFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getTaxonomicRankNameFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getCredibilityRatingFromTSN {
    my ($self, $body, $header) = @_;
    die "getCredibilityRatingFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getCredibilityRatingFromTSN',
        soap_action => 'urn:getCredibilityRatingFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getCredibilityRatingFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getITISTermsFromCommonName {
    my ($self, $body, $header) = @_;
    die "getITISTermsFromCommonName must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getITISTermsFromCommonName',
        soap_action => 'urn:getITISTermsFromCommonName',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getITISTermsFromCommonName )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub searchForAnyMatch {
    my ($self, $body, $header) = @_;
    die "searchForAnyMatch must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'searchForAnyMatch',
        soap_action => 'urn:searchForAnyMatch',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::searchForAnyMatch )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getHierarchyDownFromTSN {
    my ($self, $body, $header) = @_;
    die "getHierarchyDownFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getHierarchyDownFromTSN',
        soap_action => 'urn:getHierarchyDownFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getHierarchyDownFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getHierarchyUpFromTSN {
    my ($self, $body, $header) = @_;
    die "getHierarchyUpFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getHierarchyUpFromTSN',
        soap_action => 'urn:getHierarchyUpFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getHierarchyUpFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getGlobalSpeciesCompletenessFromTSN {
    my ($self, $body, $header) = @_;
    die "getGlobalSpeciesCompletenessFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getGlobalSpeciesCompletenessFromTSN',
        soap_action => 'urn:getGlobalSpeciesCompletenessFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getGlobalSpeciesCompletenessFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getCommentDetailFromTSN {
    my ($self, $body, $header) = @_;
    die "getCommentDetailFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getCommentDetailFromTSN',
        soap_action => 'urn:getCommentDetailFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getCommentDetailFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getFullRecordFromTSN {
    my ($self, $body, $header) = @_;
    die "getFullRecordFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getFullRecordFromTSN',
        soap_action => 'urn:getFullRecordFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getFullRecordFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getFullHierarchyFromTSN {
    my ($self, $body, $header) = @_;
    die "getFullHierarchyFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getFullHierarchyFromTSN',
        soap_action => 'urn:getFullHierarchyFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getFullHierarchyFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getUnacceptabilityReasonFromTSN {
    my ($self, $body, $header) = @_;
    die "getUnacceptabilityReasonFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getUnacceptabilityReasonFromTSN',
        soap_action => 'urn:getUnacceptabilityReasonFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getUnacceptabilityReasonFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub searchByCommonNameEndsWith {
    my ($self, $body, $header) = @_;
    die "searchByCommonNameEndsWith must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'searchByCommonNameEndsWith',
        soap_action => 'urn:searchByCommonNameEndsWith',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::searchByCommonNameEndsWith )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getScientificNameFromTSN {
    my ($self, $body, $header) = @_;
    die "getScientificNameFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getScientificNameFromTSN',
        soap_action => 'urn:getScientificNameFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getScientificNameFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getTsnByVernacularLanguage {
    my ($self, $body, $header) = @_;
    die "getTsnByVernacularLanguage must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getTsnByVernacularLanguage',
        soap_action => 'urn:getTsnByVernacularLanguage',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getTsnByVernacularLanguage )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getCurrencyFromTSN {
    my ($self, $body, $header) = @_;
    die "getCurrencyFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getCurrencyFromTSN',
        soap_action => 'urn:getCurrencyFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getCurrencyFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getKingdomNames {
    my ($self, $body, $header) = @_;
    die "getKingdomNames must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getKingdomNames',
        soap_action => 'urn:getKingdomNames',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getDateDataFromTSN {
    my ($self, $body, $header) = @_;
    die "getDateDataFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getDateDataFromTSN',
        soap_action => 'urn:getDateDataFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getDateDataFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getAcceptedNamesFromTSN {
    my ($self, $body, $header) = @_;
    die "getAcceptedNamesFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getAcceptedNamesFromTSN',
        soap_action => 'urn:getAcceptedNamesFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getAcceptedNamesFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getPublicationsFromTSN {
    my ($self, $body, $header) = @_;
    die "getPublicationsFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getPublicationsFromTSN',
        soap_action => 'urn:getPublicationsFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getPublicationsFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getTaxonomicUsageFromTSN {
    my ($self, $body, $header) = @_;
    die "getTaxonomicUsageFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getTaxonomicUsageFromTSN',
        soap_action => 'urn:getTaxonomicUsageFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getTaxonomicUsageFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub searchByScientificName {
    my ($self, $body, $header) = @_;
    die "searchByScientificName must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'searchByScientificName',
        soap_action => 'urn:searchByScientificName',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::searchByScientificName )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getLSIDFromTSN {
    my ($self, $body, $header) = @_;
    die "getLSIDFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getLSIDFromTSN',
        soap_action => 'urn:getLSIDFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getLSIDFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getRankNames {
    my ($self, $body, $header) = @_;
    die "getRankNames must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getRankNames',
        soap_action => 'urn:getRankNames',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getITISTermsFromScientificName {
    my ($self, $body, $header) = @_;
    die "getITISTermsFromScientificName must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getITISTermsFromScientificName',
        soap_action => 'urn:getITISTermsFromScientificName',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getITISTermsFromScientificName )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getJurisdictionValues {
    my ($self, $body, $header) = @_;
    die "getJurisdictionValues must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getJurisdictionValues',
        soap_action => 'urn:getJurisdictionValues',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getITISTerms {
    my ($self, $body, $header) = @_;
    die "getITISTerms must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getITISTerms',
        soap_action => 'urn:getITISTerms',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getITISTerms )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getDescription {
    my ($self, $body, $header) = @_;
    die "getDescription must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getDescription',
        soap_action => 'urn:getDescription',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getCommonNamesFromTSN {
    my ($self, $body, $header) = @_;
    die "getCommonNamesFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getCommonNamesFromTSN',
        soap_action => 'urn:getCommonNamesFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getCommonNamesFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getTaxonAuthorshipFromTSN {
    my ($self, $body, $header) = @_;
    die "getTaxonAuthorshipFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getTaxonAuthorshipFromTSN',
        soap_action => 'urn:getTaxonAuthorshipFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getTaxonAuthorshipFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getKingdomNameFromTSN {
    my ($self, $body, $header) = @_;
    die "getKingdomNameFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getKingdomNameFromTSN',
        soap_action => 'urn:getKingdomNameFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getKingdomNameFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub searchByCommonNameBeginsWith {
    my ($self, $body, $header) = @_;
    die "searchByCommonNameBeginsWith must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'searchByCommonNameBeginsWith',
        soap_action => 'urn:searchByCommonNameBeginsWith',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::searchByCommonNameBeginsWith )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getJurisdictionalOriginFromTSN {
    my ($self, $body, $header) = @_;
    die "getJurisdictionalOriginFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getJurisdictionalOriginFromTSN',
        soap_action => 'urn:getJurisdictionalOriginFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getJurisdictionalOriginFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getCredibilityRatings {
    my ($self, $body, $header) = @_;
    die "getCredibilityRatings must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getCredibilityRatings',
        soap_action => 'urn:getCredibilityRatings',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getGeographicValues {
    my ($self, $body, $header) = @_;
    die "getGeographicValues must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getGeographicValues',
        soap_action => 'urn:getGeographicValues',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw(  )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getOtherSourcesFromTSN {
    my ($self, $body, $header) = @_;
    die "getOtherSourcesFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getOtherSourcesFromTSN',
        soap_action => 'urn:getOtherSourcesFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getOtherSourcesFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}


sub getSynonymNamesFromTSN {
    my ($self, $body, $header) = @_;
    die "getSynonymNamesFromTSN must be called as object method (\$self is <$self>)" if not blessed($self);
    return $self->SUPER::call({
        operation => 'getSynonymNamesFromTSN',
        soap_action => 'urn:getSynonymNamesFromTSN',
        style => 'document',
        body => {
            

           'use'            => 'literal',
            namespace       => 'http://schemas.xmlsoap.org/wsdl/soap/',
            encodingStyle   => '',
            parts           =>  [qw( MyElements::getSynonymNamesFromTSN )],
        },
        header => {
            
        },
        headerfault => {
            
        }
    }, $body, $header);
}




1;



__END__

=pod

=head1 NAME

MyInterfaces::ITISService::ITISServiceHttpSoap11Endpoint - SOAP Interface for the ITISService Web Service

=head1 SYNOPSIS

 use MyInterfaces::ITISService::ITISServiceHttpSoap11Endpoint;
 my $interface = MyInterfaces::ITISService::ITISServiceHttpSoap11Endpoint->new();

 my $response;
 $response = $interface->getReviewYearFromTSN();
 $response = $interface->getExpertsFromTSN();
 $response = $interface->searchByCommonName();
 $response = $interface->getVernacularLanguages();
 $response = $interface->getFullRecordFromLSID();
 $response = $interface->getRecordFromLSID();
 $response = $interface->getCoverageFromTSN();
 $response = $interface->getJurisdictionalOriginValues();
 $response = $interface->getTSNFromLSID();
 $response = $interface->getCoreMetadataFromTSN();
 $response = $interface->getLastChangeDate();
 $response = $interface->getParentTSNFromTSN();
 $response = $interface->getGeographicDivisionsFromTSN();
 $response = $interface->getTaxonomicRankNameFromTSN();
 $response = $interface->getCredibilityRatingFromTSN();
 $response = $interface->getITISTermsFromCommonName();
 $response = $interface->searchForAnyMatch();
 $response = $interface->getHierarchyDownFromTSN();
 $response = $interface->getHierarchyUpFromTSN();
 $response = $interface->getGlobalSpeciesCompletenessFromTSN();
 $response = $interface->getCommentDetailFromTSN();
 $response = $interface->getFullRecordFromTSN();
 $response = $interface->getFullHierarchyFromTSN();
 $response = $interface->getUnacceptabilityReasonFromTSN();
 $response = $interface->searchByCommonNameEndsWith();
 $response = $interface->getScientificNameFromTSN();
 $response = $interface->getTsnByVernacularLanguage();
 $response = $interface->getCurrencyFromTSN();
 $response = $interface->getKingdomNames();
 $response = $interface->getDateDataFromTSN();
 $response = $interface->getAcceptedNamesFromTSN();
 $response = $interface->getPublicationsFromTSN();
 $response = $interface->getTaxonomicUsageFromTSN();
 $response = $interface->searchByScientificName();
 $response = $interface->getLSIDFromTSN();
 $response = $interface->getRankNames();
 $response = $interface->getITISTermsFromScientificName();
 $response = $interface->getJurisdictionValues();
 $response = $interface->getITISTerms();
 $response = $interface->getDescription();
 $response = $interface->getCommonNamesFromTSN();
 $response = $interface->getTaxonAuthorshipFromTSN();
 $response = $interface->getKingdomNameFromTSN();
 $response = $interface->searchByCommonNameBeginsWith();
 $response = $interface->getJurisdictionalOriginFromTSN();
 $response = $interface->getCredibilityRatings();
 $response = $interface->getGeographicValues();
 $response = $interface->getOtherSourcesFromTSN();
 $response = $interface->getSynonymNamesFromTSN();



=head1 DESCRIPTION

SOAP Interface for the ITISService web service
located at http://www.itis.gov/ITISWebService/services/ITISService.ITISServiceHttpSoap11Endpoint/.

=head1 SERVICE ITISService



=head2 Port ITISServiceHttpSoap11Endpoint



=head1 METHODS

=head2 General methods

=head3 new

Constructor.

All arguments are forwarded to L<SOAP::WSDL::Client|SOAP::WSDL::Client>.

=head2 SOAP Service methods

Method synopsis is displayed with hash refs as parameters.

The commented class names in the method's parameters denote that objects
of the corresponding class can be passed instead of the marked hash ref.

You may pass any combination of objects, hash and list refs to these
methods, as long as you meet the structure.

List items (i.e. multiple occurences) are not displayed in the synopsis.
You may generally pass a list ref of hash refs (or objects) instead of a hash
ref - this may result in invalid XML if used improperly, though. Note that
SOAP::WSDL always expects list references at maximum depth position.

XML attributes are not displayed in this synopsis and cannot be set using
hash refs. See the respective class' documentation for additional information.



=head3 getReviewYearFromTSN



Returns a L<MyElements::getReviewYearFromTSNResponse|MyElements::getReviewYearFromTSNResponse> object.

 $response = $interface->getReviewYearFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getExpertsFromTSN



Returns a L<MyElements::getExpertsFromTSNResponse|MyElements::getExpertsFromTSNResponse> object.

 $response = $interface->getExpertsFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 searchByCommonName



Returns a L<MyElements::searchByCommonNameResponse|MyElements::searchByCommonNameResponse> object.

 $response = $interface->searchByCommonName( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 getVernacularLanguages



Returns a L<MyElements::getVernacularLanguagesResponse|MyElements::getVernacularLanguagesResponse> object.

 $response = $interface->getVernacularLanguages( );

=head3 getFullRecordFromLSID



Returns a L<MyElements::getFullRecordFromLSIDResponse|MyElements::getFullRecordFromLSIDResponse> object.

 $response = $interface->getFullRecordFromLSID( {
    lsid =>  $some_value, # string
  },,
 );

=head3 getRecordFromLSID



Returns a L<MyElements::getRecordFromLSIDResponse|MyElements::getRecordFromLSIDResponse> object.

 $response = $interface->getRecordFromLSID( {
    lsid =>  $some_value, # string
  },,
 );

=head3 getCoverageFromTSN



Returns a L<MyElements::getCoverageFromTSNResponse|MyElements::getCoverageFromTSNResponse> object.

 $response = $interface->getCoverageFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getJurisdictionalOriginValues



Returns a L<MyElements::getJurisdictionalOriginValuesResponse|MyElements::getJurisdictionalOriginValuesResponse> object.

 $response = $interface->getJurisdictionalOriginValues( );

=head3 getTSNFromLSID



Returns a L<MyElements::getTSNFromLSIDResponse|MyElements::getTSNFromLSIDResponse> object.

 $response = $interface->getTSNFromLSID( {
    lsid =>  $some_value, # string
  },,
 );

=head3 getCoreMetadataFromTSN



Returns a L<MyElements::getCoreMetadataFromTSNResponse|MyElements::getCoreMetadataFromTSNResponse> object.

 $response = $interface->getCoreMetadataFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getLastChangeDate



Returns a L<MyElements::getLastChangeDateResponse|MyElements::getLastChangeDateResponse> object.

 $response = $interface->getLastChangeDate( );

=head3 getParentTSNFromTSN



Returns a L<MyElements::getParentTSNFromTSNResponse|MyElements::getParentTSNFromTSNResponse> object.

 $response = $interface->getParentTSNFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getGeographicDivisionsFromTSN



Returns a L<MyElements::getGeographicDivisionsFromTSNResponse|MyElements::getGeographicDivisionsFromTSNResponse> object.

 $response = $interface->getGeographicDivisionsFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getTaxonomicRankNameFromTSN



Returns a L<MyElements::getTaxonomicRankNameFromTSNResponse|MyElements::getTaxonomicRankNameFromTSNResponse> object.

 $response = $interface->getTaxonomicRankNameFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getCredibilityRatingFromTSN



Returns a L<MyElements::getCredibilityRatingFromTSNResponse|MyElements::getCredibilityRatingFromTSNResponse> object.

 $response = $interface->getCredibilityRatingFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getITISTermsFromCommonName



Returns a L<MyElements::getITISTermsFromCommonNameResponse|MyElements::getITISTermsFromCommonNameResponse> object.

 $response = $interface->getITISTermsFromCommonName( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 searchForAnyMatch



Returns a L<MyElements::searchForAnyMatchResponse|MyElements::searchForAnyMatchResponse> object.

 $response = $interface->searchForAnyMatch( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 getHierarchyDownFromTSN



Returns a L<MyElements::getHierarchyDownFromTSNResponse|MyElements::getHierarchyDownFromTSNResponse> object.

 $response = $interface->getHierarchyDownFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getHierarchyUpFromTSN



Returns a L<MyElements::getHierarchyUpFromTSNResponse|MyElements::getHierarchyUpFromTSNResponse> object.

 $response = $interface->getHierarchyUpFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getGlobalSpeciesCompletenessFromTSN



Returns a L<MyElements::getGlobalSpeciesCompletenessFromTSNResponse|MyElements::getGlobalSpeciesCompletenessFromTSNResponse> object.

 $response = $interface->getGlobalSpeciesCompletenessFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getCommentDetailFromTSN



Returns a L<MyElements::getCommentDetailFromTSNResponse|MyElements::getCommentDetailFromTSNResponse> object.

 $response = $interface->getCommentDetailFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getFullRecordFromTSN



Returns a L<MyElements::getFullRecordFromTSNResponse|MyElements::getFullRecordFromTSNResponse> object.

 $response = $interface->getFullRecordFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getFullHierarchyFromTSN



Returns a L<MyElements::getFullHierarchyFromTSNResponse|MyElements::getFullHierarchyFromTSNResponse> object.

 $response = $interface->getFullHierarchyFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getUnacceptabilityReasonFromTSN



Returns a L<MyElements::getUnacceptabilityReasonFromTSNResponse|MyElements::getUnacceptabilityReasonFromTSNResponse> object.

 $response = $interface->getUnacceptabilityReasonFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 searchByCommonNameEndsWith



Returns a L<MyElements::searchByCommonNameEndsWithResponse|MyElements::searchByCommonNameEndsWithResponse> object.

 $response = $interface->searchByCommonNameEndsWith( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 getScientificNameFromTSN



Returns a L<MyElements::getScientificNameFromTSNResponse|MyElements::getScientificNameFromTSNResponse> object.

 $response = $interface->getScientificNameFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getTsnByVernacularLanguage



Returns a L<MyElements::getTsnByVernacularLanguageResponse|MyElements::getTsnByVernacularLanguageResponse> object.

 $response = $interface->getTsnByVernacularLanguage( {
    language =>  $some_value, # string
  },,
 );

=head3 getCurrencyFromTSN



Returns a L<MyElements::getCurrencyFromTSNResponse|MyElements::getCurrencyFromTSNResponse> object.

 $response = $interface->getCurrencyFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getKingdomNames



Returns a L<MyElements::getKingdomNamesResponse|MyElements::getKingdomNamesResponse> object.

 $response = $interface->getKingdomNames( );

=head3 getDateDataFromTSN



Returns a L<MyElements::getDateDataFromTSNResponse|MyElements::getDateDataFromTSNResponse> object.

 $response = $interface->getDateDataFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getAcceptedNamesFromTSN



Returns a L<MyElements::getAcceptedNamesFromTSNResponse|MyElements::getAcceptedNamesFromTSNResponse> object.

 $response = $interface->getAcceptedNamesFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getPublicationsFromTSN



Returns a L<MyElements::getPublicationsFromTSNResponse|MyElements::getPublicationsFromTSNResponse> object.

 $response = $interface->getPublicationsFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getTaxonomicUsageFromTSN



Returns a L<MyElements::getTaxonomicUsageFromTSNResponse|MyElements::getTaxonomicUsageFromTSNResponse> object.

 $response = $interface->getTaxonomicUsageFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 searchByScientificName



Returns a L<MyElements::searchByScientificNameResponse|MyElements::searchByScientificNameResponse> object.

 $response = $interface->searchByScientificName( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 getLSIDFromTSN



Returns a L<MyElements::getLSIDFromTSNResponse|MyElements::getLSIDFromTSNResponse> object.

 $response = $interface->getLSIDFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getRankNames



Returns a L<MyElements::getRankNamesResponse|MyElements::getRankNamesResponse> object.

 $response = $interface->getRankNames( );

=head3 getITISTermsFromScientificName



Returns a L<MyElements::getITISTermsFromScientificNameResponse|MyElements::getITISTermsFromScientificNameResponse> object.

 $response = $interface->getITISTermsFromScientificName( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 getJurisdictionValues



Returns a L<MyElements::getJurisdictionValuesResponse|MyElements::getJurisdictionValuesResponse> object.

 $response = $interface->getJurisdictionValues( );

=head3 getITISTerms



Returns a L<MyElements::getITISTermsResponse|MyElements::getITISTermsResponse> object.

 $response = $interface->getITISTerms( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 getDescription



Returns a L<MyElements::getDescriptionResponse|MyElements::getDescriptionResponse> object.

 $response = $interface->getDescription( );

=head3 getCommonNamesFromTSN



Returns a L<MyElements::getCommonNamesFromTSNResponse|MyElements::getCommonNamesFromTSNResponse> object.

 $response = $interface->getCommonNamesFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getTaxonAuthorshipFromTSN



Returns a L<MyElements::getTaxonAuthorshipFromTSNResponse|MyElements::getTaxonAuthorshipFromTSNResponse> object.

 $response = $interface->getTaxonAuthorshipFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getKingdomNameFromTSN



Returns a L<MyElements::getKingdomNameFromTSNResponse|MyElements::getKingdomNameFromTSNResponse> object.

 $response = $interface->getKingdomNameFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 searchByCommonNameBeginsWith



Returns a L<MyElements::searchByCommonNameBeginsWithResponse|MyElements::searchByCommonNameBeginsWithResponse> object.

 $response = $interface->searchByCommonNameBeginsWith( {
    srchKey =>  $some_value, # string
  },,
 );

=head3 getJurisdictionalOriginFromTSN



Returns a L<MyElements::getJurisdictionalOriginFromTSNResponse|MyElements::getJurisdictionalOriginFromTSNResponse> object.

 $response = $interface->getJurisdictionalOriginFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getCredibilityRatings



Returns a L<MyElements::getCredibilityRatingsResponse|MyElements::getCredibilityRatingsResponse> object.

 $response = $interface->getCredibilityRatings( );

=head3 getGeographicValues



Returns a L<MyElements::getGeographicValuesResponse|MyElements::getGeographicValuesResponse> object.

 $response = $interface->getGeographicValues( );

=head3 getOtherSourcesFromTSN



Returns a L<MyElements::getOtherSourcesFromTSNResponse|MyElements::getOtherSourcesFromTSNResponse> object.

 $response = $interface->getOtherSourcesFromTSN( {
    tsn =>  $some_value, # string
  },,
 );

=head3 getSynonymNamesFromTSN



Returns a L<MyElements::getSynonymNamesFromTSNResponse|MyElements::getSynonymNamesFromTSNResponse> object.

 $response = $interface->getSynonymNamesFromTSN( {
    tsn =>  $some_value, # string
  },,
 );



=head1 AUTHOR

Generated by SOAP::WSDL on Wed Jun  6 18:38:58 2012

=cut
