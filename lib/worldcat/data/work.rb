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
  module Data
    
    # == Properties mapped from RDF data
    #
    # RDF properties are mapped via an ORM style mapping.
    # 
    #   work = WorldCat::Identifiers::Work.find(http://worldcat.org/entity/work/id/67201841)
    #   work.name        # => "Programming Ruby."
    #
    # [subjects] RDF predicate: http://schema.org/about; returns: Enumerable of RDF::URI objects
    # [types] RDF predicate: http://www.w3.org/1999/02/22-rdf-syntax-ns#type; returns: RDF::URI
    # [authors] RDF predicate: http://schema.org/authors; returns: Enumerable of RDF::URI objects
    # [contributors] RDF predicate: http://schema.org/contributor; returns: Enumerable of RDF::URI objects
    # [creators] RDF predicate: http://schema.org/creator; returns: Enumerable of RDF::URI objects
    # [descriptions] RDF predicate: http://schema.org/description; returns: Enumerable of String objects
    # [work_examples] RDF predicate: http://schema.org/workExample; returns: Enumerable of WorldCat::Discovery::Bib objects
    
    class Work < Spira::Base
      
      attr_accessor :response_body, :response_code, :result
      
      has_many :subjects, :predicate => SCHEMA_ABOUT, :type => RDF::URI
      has_many :types, :predicate => RDF.type, :type => RDF::URI
      has_many :authors, :predicate => SCHEMA_AUTHOR, :type => RDF::URI
      has_many :contributors, :predicate => SCHEMA_CONTRIBUTOR, :type => RDF::URI
      has_many :creators, :predicate => SCHEMA_CREATOR, :type => RDF::URI
      has_many :descriptions, :predicate => SCHEMA_DESCRIPTION, :type => XSD.string
      has_many :work_examples, :predicate => SCHEMA_WORK_EXAMPLE, :type => 'Bib'
          
      
      # call-seq:
      #   id() => RDF::URI
      # 
      # Will return the RDF::URI object that serves as the RDF subject of the current Bib
      def id
        self.subject
      end
      
      def alternate_names
        alternative_name_statements = Spira.repository.query(:subject => self.id, :predicate => SCHEMA_ALT_NAME)
        alternative_names = alternative_name_statements.map {|statement| statement.object}
      end
      
      def genres
        genre_statements = Spira.repository.query(:subject => self.id, :predicate => SCHEMA_GENRE)
        genres = genre_statements.map {|statement| statement.object}
      end
      
      def names
        name_statements = Spira.repository.query(:subject => self.id, :predicate => SCHEMA_NAME)
        names = name_statements.map {|statement| statement.object}
      end
      
                       
      # call-seq:
      #   find(work_uri) => WorldCat::Data::Work
      # 
      # Returns a Work resource for the given Work URI
      #
      # [work_uri] the URI for a bibliographic resource in WorldCat
      def self.find(work_uri)
        url = work_uri
        response, result = WorldCat::Data.get_data(url)
        
        if result.class == Net::HTTPOK
          # Load the data into an in-memory RDF repository, get the GenericResource and its Bib
          Spira.repository = RDF::Repository.new.from_rdfxml(response)
          work_object = Spira.repository.query(:predicate => RDF.type, :object => WORK).first
          work = work_object.subject.as(Work)
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
      
      def load_work_group
        ## load all the data from the OCLC Numbers in the work into the graph
        work_group_store = RDF::Repository.new.from_rdfxml(self.response_body)
        self.work_examples.each{|work_example|
          response, result = WorldCat::Data.get_data(work_example.id.to_s) 
          RDF::Reader.for(:rdfxml).new(response) do |reader|
            reader.each_statement do |statement|
              work_group_store.insert(statement)
            end
          end
          #another way to load the data if it isn't open
          #work_group_store.load(work_example.id.to_s)
        }
        work_group_store
        
      end
      
      def oclc_numbers
        work_group_store = self.load_work_group
        #run the sparql here to get what we want
        results = SPARQL.execute("SELECT ?oclc_number WHERE {?s <http://purl.org/library/oclcnum> ?oclc_number.}", work_group_store)
        oclc_numbers = results.map{|result| result.oclc_number.value}
      end
      
      def isbns
        work_group_store = self.load_work_group
        # run the SPARQL here to get what we want
        results = SPARQL.execute("SELECT ?isbn WHERE {?s <http://schema.org/isbn> ?isbn.}", work_group_store)
        isbns = results.map{|result| result.isbn.value}
      end
      

    end
  end
end