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

describe WorldCat::Data::Bib do
  
  context "when loading bibliographic data" do

    context "from a single resource from the RDF data for The Wittgenstein Reader" do
      before(:all) do
        url = 'http://worldcat.org/oclc/30780581'
        stub_request(:get, url).to_return(:body => body_content("30780581.rdf"), :status => 200)
        @bib = WorldCat::Data::Bib.find('http://worldcat.org/oclc/30780581')
      end

      it "should have the right id" do
        @bib.id.should == "http://www.worldcat.org/oclc/30780581"
      end

      it "should have the right name" do
        @bib.name.should == "The Wittgenstein reader"
      end

      it "should have the right OCLC number" do
        @bib.oclc_number.should == 30780581
      end

      it "should have the right work URI" do
        @bib.work_uri.should == RDF::URI.new('http://worldcat.org/entity/work/id/45185752')
      end

      #deprecated property
      #it "should have the right number of pages" do
      #   @bib.num_pages.should == "312"
      #end
      
      it "should have the right date published" do
        @bib.date_published.should == "1994"
      end

      it "should have the right type" do
        @bib.type.should == RDF::URI.new('http://schema.org/Book')
      end

      #deprecated property
      #it "should have the right OWL same as property" do
      #  @bib.same_as.should == RDF::URI.new("info:oclcnum/30780581")
      #end

      it "should have the right language" do
        @bib.language.should == "en"
      end

      it "should have the right author" do
        @bib.author.class.should == WorldCat::Data::Person
        @bib.author.name.should == "Wittgenstein, Ludwig, 1889-1951."
      end

      it "should have the right publisher" do
        @bib.publisher.class.should == WorldCat::Data::Organization
        @bib.publisher.name.should == "B. Blackwell"
      end

      it "should have the right contributors" do
        @bib.contributors.size.should == 1
        contributor = @bib.contributors.first
        contributor.class.should == WorldCat::Data::Person
        contributor.name.should == "Kenny, Anthony, 1931-"
      end

      it "should have the right subjects" do
        subjects = @bib.subjects
        subjects.each {|subject| subject.class.should == WorldCat::Data::Subject}

        subject_ids = subjects.map {|subject| subject.id}
        subject_ids.should include(RDF::URI('http://dewey.info/class/192/e20/'))
        subject_ids.should include(RDF::URI('http://id.loc.gov/authorities/classification/B3376'))
        subject_ids.should include(RDF::URI('http://id.worldcat.org/fast/1060777'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Topic/filosofia_contemporanea_alemanha'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Topic/wissenschaftstheorie'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Topic/analytische_philosophie'))

        subject_names = subjects.map {|subject| subject.name}
        subject_names.should include("Filosofia contemporânea--Alemanha.")
        subject_names.should include("Wissenschaftstheorie.")
        subject_names.should include("Analytische Philosophie.")
        subject_names.should include("Philosophy.")
      end

      it "should have the right work examples" do
        work_examples = @bib.work_examples
        work_examples.each {|product_model| product_model.class.should == WorldCat::Data::ProductModel}

        work_example_uris = work_examples.map {|product_model| product_model.id}
        work_example_uris.should include(RDF::URI('http://worldcat.org/isbn/9780631193616'))
        work_example_uris.should include(RDF::URI('http://worldcat.org/isbn/9780631193623'))
      end

      it "should have the right places of publication" do
        places_of_publication = @bib.places_of_publication
        places_of_publication.size.should == 3

        oxford = places_of_publication.reduce(nil) do |p, place| 
          p = place if place.id == RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Place/oxford_uk')
          p
        end
        oxford.class.should == WorldCat::Data::Place
        oxford.type.should == 'http://schema.org/Place'
        oxford.name.should == 'Oxford, UK'

        cambridge = places_of_publication.reduce(nil) do |p, place|
          if place.id == RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Place/cambridge_mass_usa')
            p = place 
          end
          p
        end
        cambridge.class.should == WorldCat::Data::Place
        cambridge.type.should == 'http://schema.org/Place'
        cambridge.name.should == 'Cambridge, Mass., USA'

        england = places_of_publication.reduce(nil) {|p, place| p = place if place.id == RDF::URI('http://id.loc.gov/vocabulary/countries/enk'); p}
        england.class.should == WorldCat::Data::Place
        england.type.should == 'http://schema.org/Place'      
      end

      it "should have the right descriptions" do
        descriptions = @bib.descriptions
        descriptions.size.should == 2

        File.open("#{File.expand_path(File.dirname(__FILE__))}/../../support/text/30780581_descriptions.txt").each do |line|
          descriptions.should include(line.chomp)
        end
      end

      it "should have the right isbns" do
        @bib.isbns.sort.should == ["0631193618", "0631193626", "9780631193616", "9780631193623"]
      end
    end

    context "from a single resource from the RDF data for The Big Typescript" do
      before(:all) do
        url = 'http://worldcat.org/oclc/57422379'
        stub_request(:get, url).to_return(:body => body_content("57422379.rdf"), :status => 200)
        @bib = WorldCat::Data::Bib.find('http://worldcat.org/oclc/57422379')
      end

      it "should have the right book edition" do
        @bib.book_edition.should == "German-English scholar's ed."
      end

      it "should have the right reviews" do
        reviews = @bib.reviews
        reviews.size.should == 1

        review_bodies = reviews.map {|review| review.body}
        File.open("#{File.expand_path(File.dirname(__FILE__))}/../../support/text/57422379_reviews.txt").each do |line|
          review_bodies.should include(line.chomp)
        end
      end
    end

    context "from data for bib resources that don't have personal authors" do
      it "should handle books with no author" do
        url = 'http://worldcat.org/oclc/45621749'
        stub_request(:get, url).to_return(:body => body_content("45621749.rdf"), :status => 200)
        bib = WorldCat::Data::Bib.find('http://worldcat.org/oclc/45621749')

        bib.author.should == nil
      end
      
      it "should handle authors that are organizations" do
        url = 'http://worldcat.org/oclc/233192257'
        stub_request(:get, url).to_return(:body => body_content("233192257.rdf"), :status => 200)
        bib = WorldCat::Data::Bib.find('http://worldcat.org/oclc/233192257')

        bib.author.class.should == WorldCat::Data::Organization
        bib.author.name.should == "United States. National Park Service."
      end
    end
    
    context "from data that uses the schema:author property" do
      it "should have the correct author data" do
        url = 'http://worldcat.org/oclc/30780581'
        stub_request(:get, url).to_return(:body => body_content("30780581-v1.rdf"), :status => 200)
        bib = WorldCat::Data::Bib.find('http://worldcat.org/oclc/30780581')

        bib.author.class.should == WorldCat::Data::Person
        bib.author.name.should == "Wittgenstein, Ludwig, 1889-1951."
      end
    end
  end
end