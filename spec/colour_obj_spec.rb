require "spec_helper"
require 'colour_obj'

describe ColourObj::Colour do
  describe "Initialization" do
    it "can initialize with no params" do
      col= ColourObj::Colour.new
      col.red.should eql 0
      col.green.should eql 0
      col.blue.should eql 0
    end

    it "can initialize with an int array of length 3" do
      col= ColourObj::Colour.new([0, 0, 0])
      col.red.should eql 0
      col.green.should eql 0
      col.blue.should eql 0
    end

    it "can initialize with a string of hex with length 6" do
      col= ColourObj::Colour.new("000000")
      col.red.should eql 0
      col.green.should eql 0
      col.blue.should eql 0
    end

  end

  describe "setting colour" do
    before(:each) do
      @col = ColourObj::Colour.new
    end

    describe "by rgb int triplet" do


      it "works correctly from an int array that is an RGB triplet" do
        @col.set_colour([1, 2, 3])
        col_should_eql(@col, 1, 2, 3)
      end

      it "should only accept arrays of length 3" do
        expect {
          @col.set_colour([])
        }.to raise_error ArgumentError

        expect {
          @col.set_colour([1])
        }.to raise_error ArgumentError

        expect {
          @col.set_colour([1, 2])
        }.to raise_error ArgumentError

        expect {
          @col.set_colour([1, 2, 3, 4])
        }.to raise_error ArgumentError

      end

      it "should only accept arrays of integers" do
        expect {
          @col.set_colour(["a", "b", "c"])
        }.to raise_error TypeError

        expect {
          @col.set_colour([1, 2, "three"])
        }.to raise_error TypeError

      end
    end

    describe "by hex string" do
      before(:all) do
        TEST_HEX_COLOUR = "FEEED0"
        TEST_RED = 254
        TEST_GREEN = 238
        TEST_BLUE = 208
      end

      it "can parse a basic, properly formed hex colour string" do
        @col.set_colour("010203")
        col_should_eql(@col, 1, 2, 3)
      end

      it "can set colour correctly from a properly formed hex colour string" do
        @col.set_colour(TEST_HEX_COLOUR)
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)
      end

      it "can use lowercase hex" do
        @col.set_colour(TEST_HEX_COLOUR.downcase)
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)
      end

      it "works with or without leading #" do
        @col.set_colour("\##{TEST_HEX_COLOUR}")
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)

        @col.set_colour("\##{TEST_HEX_COLOUR.downcase}")
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)
      end

      it "should reject short strings" do
        expect {
          @col.set_colour("")
        }.to raise_error ArgumentError

        expect {
          @col.set_colour("ABC")
        }.to raise_error ArgumentError

        expect {
          @col.set_colour("ABCDE")
        }.to raise_error ArgumentError

        expect {
          @col.set_colour("#ABCDE")
        }.to raise_error ArgumentError

      end

      it "should reject long strings" do
        expect {
          @col.set_colour("ABCDEFF")
        }.to raise_error ArgumentError

        expect {
          @col.set_colour("AABBCCDD")
        }.to raise_error ArgumentError

      end

      it "should reject strings that contain non-hex digits" do
        expect {
          @col.set_colour("0000GG")
        }.to raise_error ArgumentError

      end

      it "should ignore non [A-Za-z0-9] characters" do
        red= TEST_HEX_COLOUR[0, 2]
        green = TEST_HEX_COLOUR[2, 2]
        blue = TEST_HEX_COLOUR[4, 2]

        str1 = "#{red},#{green},#{blue}"
        str2 = "#{red}:#{green}:#{blue}"
        str3 = "<#{red} #{green} #{blue}>"

        @col.set_colour(str1)
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)

        @col.set_colour(str2)
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)

        @col.set_colour(str3)
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)

      end

    end

  end

end

def col_should_eql(col, r, g, b)
  col.red.should eql r
  col.green.should eql g
  col.blue.should eql b
end
    