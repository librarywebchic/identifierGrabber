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

require_relative '../../spec_helper'

describe WorldCat::Identifiers::Work do
  
  context "when loading work data" do

    context "from a single resource from the RDF data for RESTful web services" do
      before(:all) do
        url = 'http://worldcat.org/entity/work/id/672018411'
        stub_request(:get, url).to_return(:body => body_content("work_67201841.rdf"), :status => 200)
        @work = WorldCat::Identifiers::Work.find('http://worldcat.org/entity/work/id/67201841')
      end

      it "should have the right id" do
        @work.id.should == "http://worldcat.org/entity/work/id/67201841"
      end

      it "should have the right names" do
        names = @work.names
        names_values = names.map {|name| name.value}
        names_values.should include("Services web RESTful : [des services web efficaces]")
        names_values.should include("Restfull web services")
        names_values.should include("RESTful web services")
        names_values.should include("RESTful web services")
        names_values.should include("Web-Services mit REST")
        names_values.should include("RESTful Web Services")
        names_values.should include("Services Web RESTful")
        names_values.should include("Web Services mit REST")
        names_values.should include("Web-Services mit REST : [frischer Wind für Web-Services durch REST]")
        names_values.should include("RESTful web services : [web services for the real world]")
      end
      
      it "should have the right alternative_names" do
        alternative_names = @work.alternative_names
        alternative_names_values = alternative_names.map {|alternative_name| alternative_name.value}
        alternative_names_values.should include("REST架构的网络服务")
        alternative_names_values.should include("REST jia gou de wang luo fu wu")        
      end

      it "should have the right work URI" do
        @work.work_uri.should == RDF::URI.new('http://worldcat.org/entity/work/id/45185752')
      end

      it "should have the right types" do
        @work.types.should == include(RDF::URI.new('http://schema.org/Book'))
        @work.types.should == include(RDF::URI.new('http://schema.org/CreativeWork'))
      end

      it "should have the right authors" do
        authors = @work.authors
        author_uris = authors.map {|author| author.subject}
        author_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2637446024'))
        author_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2632695367'))
        author_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2641690132'))
      end

      it "should have the right creators" do
        creators = @work.creators
        creator_uris = creators.map {|creator| creator.subject}
        creator_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2632695367'))
      end

      it "should have the right contributors" do
        contributors = @work.contributors
        contributor_uris = contributors.map {|contributor| contributor.subject}
        contributor_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2641050084'))
        contributor_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2632695367'))
        contributor_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2651317527'))
        contributor_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2742580806'))
        contributor_uris.should include(RDF::URI('http://worldcat.org/entity/person/id/2637446024'))
      end

      it "should have the right subjects" do
        subjects = @work.subjects

        subject_ids = subjects.map {|subject| subject.subject}
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/programmatuurtechniek'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/websites'))
        subject_ids.should include(RDF::URI(' http://experiment.worldcat.org/entity/work/data/67201841#Topic/conception_web'))
        subject_ids.should include(RDF::URI(' http://experiment.worldcat.org/entity/work/data/67201841#Topic/architecture_orientee_services'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/sites_web_developpement'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/computers_web_web_programming'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/programmierung'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/services_web'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/rest'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/hojas_de_estilo_en_cascada'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/web_services'))
        subject_ids.should include(RDF::URI(' http://experiment.worldcat.org/entity/work/data/67201841#Topic/rest_architecture_logicielle'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/html_langage_de_balisage'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/rest_informatique'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/rest_informatique_service_web'))
        subject_ids.should include(RDF::URI('http://id.worldcat.org/fast/1173242'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/web'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/xml_langage_de_balisage'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/rest_&lt_informatik&gt'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/rest_informatik'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/serveis_web'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/service_web'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/67201841#Topic/servicios_web'))
        subject_ids.should include(RDF::URI('http://id.loc.gov/authorities/subjects/sh2003001435'))
      end

      it "should have the right work examples" do
        work_examples = @work.work_examples
        work_examples.each {|bib| bib.class.should == WorldCat::Identifiers::Bib}

        work_example_uris = work_examples.map {|bib| bib.id}
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/660967222'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/326799313'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/886700555'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/431591368'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/188235414'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/234290815'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/718524646'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/154684429'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/756523287'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/421705147'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/481822502'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/886581845'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/804438865'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/493390155'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/876558200'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/884006311'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/768470693'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/354466211'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/255474401'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/82671871'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/754004270'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/850798262'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/717007464'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/768120530'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/439080694'))
        work_example_uris.should include(RDF::URI('http://www.worldcat.org/oclc/840398604'))
      end


      it "should have the right descriptions" do
        descriptions = @work.descriptions
        descriptions.size.should == 2

        File.open("#{File.expand_path(File.dirname(__FILE__))}/../../support/text/work_67201841_descriptions.txt").each do |line|
          descriptions.should include(line.chomp)
        end
      end
      
      it "should have the right genres" do
        genres = @work.genres
        genres.size.should == 2
        genre_values = genres.map {|genre| genre.value}
        genre_values.should include('Livres électroniques')
        genre_values.should include('Electronic books')
      end
    end
    
    context "from a single resource from the RDF data for RESTful web services" do
      before(:all) do
        url = 'http://worldcat.org/entity/work/id/672018411'
        stub_request(:get, url).to_return(:body => body_content("work_67201841.rdf"), :status => 200)
        @work = WorldCat::Identifiers::Work.find('http://worldcat.org/entity/work/id/67201841')
        
        url = 'http://worldcat.org/entity/work/id/672018411'
        stub_request(:get, url).to_return(:body => body_content("work_67201841.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/660967222').to_return(:body => body_content("bib_660967222.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/326799313').to_return(:body => body_content("bib_326799313.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/886700555').to_return(:body => body_content("bib_886700555.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/431591368').to_return(:body => body_content("bib_431591368.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/188235414').to_return(:body => body_content("bib_188235414.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/234290815').to_return(:body => body_content("bib_234290815.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/718524646').to_return(:body => body_content("bib_718524646.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/154684429').to_return(:body => body_content("bib_154684429.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/756523287').to_return(:body => body_content("bib_756523287.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/421705147').to_return(:body => body_content("bib_421705147.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/481822502').to_return(:body => body_content("bib_481822502.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/886581845').to_return(:body => body_content("bib_886581845.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/804438865').to_return(:body => body_content("bib_804438865.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/493390155').to_return(:body => body_content("bib_493390155.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/876558200').to_return(:body => body_content("bib_876558200.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/884006311').to_return(:body => body_content("bib_884006311.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/768470693').to_return(:body => body_content("bib_768470693.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/354466211').to_return(:body => body_content("bib_354466211.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/255474401').to_return(:body => body_content("bib_255474401.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/82671871').to_return(:body => body_content("bib_82671871.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/754004270').to_return(:body => body_content("bib_754004270.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/850798262').to_return(:body => body_content("bib_850798262.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/768120530').to_return(:body => body_content("bib_717007464.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/768120530').to_return(:body => body_content("bib_768120530.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/439080694').to_return(:body => body_content("bib_439080694.rdf"), :status => 200)
        stub_request(:get, 'http://www.worldcat.org/oclc/840398604').to_return(:body => body_content("bib_840398604.rdf"), :status => 200)
        work_group_store = @work.load_work_group
        
        oclc_numbers = @work.oclc_numbers
        
        isbns = @work.isbns
      end
    end
    
  end
end