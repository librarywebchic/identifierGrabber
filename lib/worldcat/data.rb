require "equivalent-xml"
require "rdf"
require "rdf/rdfxml"
require 'rest_client'
require "spira"
require "addressable/uri"
require 'rubygems'
require 'sparql'

require "worldcat/data/version"
require "worldcat/data/uris"
require "worldcat/data/generic_resource"
require "worldcat/data/bib"
require "worldcat/data/work"
require "worldcat/data/person"
require "worldcat/data/organization"
require "worldcat/data/subject"
require "worldcat/data/product_model"
require "worldcat/data/place"
require "worldcat/data/series"
require "worldcat/data/review"
require "worldcat/data/client_request_error"


module WorldCat
    module Data
        class << self
        
            def get_data(url)
                # Make the HTTP request for the data
                resource = RestClient::Resource.new url
                resource.get(:user_agent => "WorldCat::Identifiers Ruby gem / #{WorldCat::Data::VERSION}",
                    :accept => 'application/rdf+xml') do |response, request, result|
                    [response, result]
                end
            end
        end
    end
end