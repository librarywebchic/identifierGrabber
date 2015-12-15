require "equivalent-xml"
require "rdf"
require "rdf/rdfxml"
require "oclc/auth"
require 'rest_client'
require "spira"
require "addressable/uri"

require "worldcat/identifiers/bib"
require "worldcat/identifiers/work"

module WorldCat
    module Identifiers
        class << self
        
            def get_data(url)
                # Make the HTTP request for the data
                resource = RestClient::Resource.new url
                resource.get(:authorization => auth, 
                    :user_agent => "WorldCat::Identifiers Ruby gem / #{WorldCat::Identifiers::VERSION}",
                    :accept => 'application/rdf+xml') do |response, request, result|
                    [response, result]
                end
            end
        end
    end
end