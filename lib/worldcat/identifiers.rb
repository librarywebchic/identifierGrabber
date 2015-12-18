require "equivalent-xml"
require "rdf"
require "rdf/rdfxml"
require "oclc/auth"
require 'rest_client'
require "spira"
require "addressable/uri"

require "worldcat/identifiers/version"
require "worldcat/identifiers/uris"
require "worldcat/identifiers/generic_resource"
require "worldcat/identifiers/bib"
require "worldcat/identifiers/work"
require "worldcat/identifiers/person"
require "worldcat/identifiers/organization"
require "worldcat/identifiers/subject"
require "worldcat/identifiers/product_model"
require "worldcat/identifiers/place"
require "worldcat/identifiers/series"
require "worldcat/identifiers/review"
require "worldcat/identifiers/client_request_error"


module WorldCat
    module Identifiers
        class << self
        
            def get_data(url)
                # Make the HTTP request for the data
                resource = RestClient::Resource.new url
                resource.get(:user_agent => "WorldCat::Identifiers Ruby gem / #{WorldCat::Identifiers::VERSION}",
                    :accept => 'application/rdf+xml') do |response, request, result|
                    [response, result]
                end
            end
        end
    end
end