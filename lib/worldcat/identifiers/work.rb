# Copyright 2014 OCLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module WorldCat
  module Identifiers
    
    # == Properties mapped from RDF data
    #
    # RDF properties are mapped via an ORM style mapping.
    # 
    #   work = WorldCat::Identifiers::Work.find(http://worldcat.org/entity/work/id/15555393)
    #   work.name        # => "Programming Ruby."
    #
    # [subjects] RDF predicate: http://schema.org/about; returns: Enumerable of RDF::URI objects
    # [alternateName] RDF predicate: http://schema.org/alternateName; returns: String
    # [types] RDF predicate: http://www.w3.org/1999/02/22-rdf-syntax-ns#type; returns: RDF::URI
    # [authors] RDF predicate: http://schema.org/authors; returns: Enumerable of RDF::URI objects
    # [contributors] RDF predicate: http://schema.org/contributor; returns: Enumerable of RDF::URI objects
    # [creators] RDF predicate: http://schema.org/creator; returns: Enumerable of RDF::URI objects
    # [descriptions] RDF predicate: http://schema.org/description; returns: Enumerable of String objects
    # [genres] RDF predicate: http://schema.org/genre, returns: Enumerable of RDF::Literal objects
    # [names] RDF predicate: http://schema.org/name, returns: Enumerable of RDF::Literal objects
    # [work_examples] RDF predicate: http://schema.org/workExample; returns: Enumerable of WorldCat::Discovery::Bib objects
    
    
    class Work < Spira::Base
      
      attr_accessor :response_body, :response_code, :result
      
      has_many :subjects, :predicate => SCHEMA_ABOUT, :type => RDF::URI
      has_many :alternate_name, :predicate => SCHEMA_ALT_NAME, :type => RDF::Literal
      has_many :types, :predicate => RDF.type, :type => RDF::URI
      has_many :authors, :predicate => SCHEMA_AUTHOR, :type => RDF::URI
      has_many :contributors, :predicate => SCHEMA_CONTRIBUTOR, :type => RDF::URI
      has_many :creators, :predicate => SCHEMA_CREATOR, :type => RDF::URI
      has_many :descriptions, :predicate => SCHEMA_DESCRIPTION, :type => XSD.string
      has_many :genres, :predicate => SCHEMA_GENRE, :type => RDF::Literal
      has_many :names, :predicate => SCHEMA_NAME, :type => RDF::Literal
      has_many :work_examples, :predicate => SCHEMA_WORK_EXAMPLE, :type => 'Bib'
          
      
      # call-seq:
      #   id() => RDF::URI
      # 
      # Will return the RDF::URI object that serves as the RDF subject of the current Bib
      def id
        self.subject
      end
                       
      # call-seq:
      #   find(work_uri) => WorldCat::Identifiers::Work
      # 
      # Returns a Work resource for the given Work URI
      #
      # [bib_uri] the URI for a bibliographic resource in WorldCat
      def self.find(work_uri)
        url = work_uri
        response, result = WorldCat::Identifiers.get_data(url)
        
        if result.class == Net::HTTPOK
          # Load the data into an in-memory RDF repository, get the GenericResource and its Bib
          Spira.repository = RDF::Repository.new.from_rdfxml(response)
          work_object = Spira.repository.query(:predicate => RDF.type, :object => WORK).first
          work = work.object.as(Bib)
          work.response_body = response
          work.response_code = response.code
          work.result = result
          
          work
          
        else
          client_request_error = ClientRequestError.new
          client_request_error.response_body = response
          client_request_error.response_code = response.code
          client_request_error.result = result
          client_request_error
        end
      end
      
      def self.load_work_group
        ## load all the data from the OCLC Numbers in the work into the graph
        work_group_store = RDF::Repository.new.from_rdfxml(self.response_body)
        self.work_examples.each{|work_example|
          response, result = WorldCat::Identifiers.get_data(work_example)
          work_group_store.from_rdf_xml(response)
        }
        work_group_store
        
      end
      
      def self.oclc_numbers
        work_graph = RDF::Repository.new.from_rdfxml(self.response_body)
        #run the sparql here to get what we want
        
      end
      
      def self.isbns
        work_group_store = self.load_work_group
        # run the SPARQL here to get what we want
      end
      

    end
  end
end