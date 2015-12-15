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

    context "from a single resource from the RDF data for The Wittgenstein Reader" do
      before(:all) do
        url = 'http://experiment.worldcat.org/entity/work/data/67201841'
        stub_request(:get, url).to_return(:body => body_content("work_67201841.rdf"), :status => 200)
        @work = WorldCat::Identifiers::Work.find(30780581)
      end

      it "should have the right id" do
        @work.id.should == "http://www.worldcat.org/oclc/30780581"
      end

      it "should have the right name" do
        @work.name.should == "The Wittgenstein reader"
      end

      it "should have the right work URI" do
        @work.work_uri.should == RDF::URI.new('http://worldcat.org/entity/work/id/45185752')
      end

      it "should have the right type" do
        @work.type.should == RDF::URI.new('http://schema.org/Book')
      end

      it "should have the right author" do
        @work.author.class.should == WorldCat::Identifiers::Person
        @work.author.name.should == "Wittgenstein, Ludwig, 1889-1951."
      end

      it "should have the right publisher" do
        @work.publisher.class.should == WorldCat::Identifiers::Organization
        @work.publisher.name.should == "B. Blackwell"
      end

      it "should have the right contributors" do
        @work.contributors.size.should == 1
        contributor = @work.contributors.first
        contributor.class.should == WorldCat::Identifiers::Person
        contributor.name.should == "Kenny, Anthony, 1931-"
      end

      it "should have the right subjects" do
        subjects = @work.subjects
        subjects.each {|subject| subject.class.should == WorldCat::Identifiers::Subject}

        subject_ids = subjects.map {|subject| subject.id}
        subject_ids.should include(RDF::URI('http://dewey.info/class/192/e20/'))
        subject_ids.should include(RDF::URI('http://id.loc.gov/authorities/classification/B3376'))
        subject_ids.should include(RDF::URI('http://id.worldcat.org/fast/1060777'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Topic/filosofia_contemporanea_alemanha'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Topic/wissenschaftstheorie'))
        subject_ids.should include(RDF::URI('http://experiment.worldcat.org/entity/work/data/45185752#Topic/analytische_philosophie'))

      end

      it "should have the right work examples" do
        work_examples = @work.work_examples
        work_examples.each {|product_model| product_model.class.should == WorldCat::Identifiers::ProductModel}

        work_example_uris = work_examples.map {|product_model| product_model.id}
        work_example_uris.should include(RDF::URI('http://worldcat.org/isbn/9780631193616'))
        work_example_uris.should include(RDF::URI('http://worldcat.org/isbn/9780631193623'))
      end


      it "should have the right descriptions" do
        descriptions = @work.descriptions
        descriptions.size.should == 2

        File.open("#{File.expand_path(File.dirname(__FILE__))}/../../support/text/30780581_descriptions.txt").each do |line|
          descriptions.should include(line.chomp)
        end
      end

      it "should have the right isbns" do
        @work.isbns.sort.should == ['9780631193616', '9780631193623']
      end
    end
    
    context "from data that uses the schema:author property" do
      it "should have the correct author data" do
        url = 'https://beta.worldcat.org/Identifiers/work/data/30780581'
        stub_request(:get, url).to_return(:body => body_content("30780581-v1.rdf"), :status => 200)
        work = WorldCat::Identifiers::Work.find(30780581)

        work.author.class.should == WorldCat::Identifiers::Person
        work.author.name.should == "Wittgenstein, Ludwig, 1889-1951."
      end
    end
  end
end