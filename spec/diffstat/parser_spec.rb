require 'spec_helper'

module DiffStat
  describe Parser do
    before(:each) do
      diff = File.read(File.dirname(__FILE__) + '/examples/example1.diff')
      @stat = Parser.new(diff).parse
    end
    
    it "should parse all files in diff" do
      @stat.should have(2).items
    end

    context "first file" do
      let(:first) { @stat[0] }

      it "should have correct name" do
        first.name.should == 'example_file_1'
      end

      it "should have correct number of line additions" do
        first.additions.should == 7
      end

      it "should have correct number of line deletions" do
        first.deletions.should == 6
      end

      it "should have correct number of line modifications" do
        first.modifications.should == 2
      end
    end

    context "second file" do
      let(:second) { @stat[1] }

      it "should have correct name" do
        second.name.should == 'example_file_2'
      end

      it "should have correct number of line additions" do
        second.additions.should == 4
      end

      it "should have correct number of line deletions" do
        second.deletions.should == 0
      end

      it "should have correct number of line modifications" do
        second.modifications.should == 0
      end
    end
  end
end
