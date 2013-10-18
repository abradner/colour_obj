require "spec_helper"
require 'colour_obj'

describe ColourObj::Colour do
  before(:all) do
    TEST_HEX_COLOUR = "feeed0"
    TEST_RED = 254
    TEST_GREEN = 238
    TEST_BLUE = 208
  end
  describe "Initialization" do
    it "can initialize with no params" do
      col= ColourObj::Colour.new
      col.red.should eql 0
      col.green.should eql 0
      col.blue.should eql 0
    end

    it "cannot issue with any arbitrary type" do
      expect {
        ColourObj::Colour.new(Object.new)
      }.to raise_error ArgumentError
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

      it "should cap integer colour values from 0.255" do
         @col.set_colour [500,-500,256]
         col_should_eql @col, 255, 0, 255
      end


    end

    describe "by hex string" do

      it "can parse a basic, properly formed hex colour string" do
        @col.set_colour("010203")
        col_should_eql(@col, 1, 2, 3)
      end

      it "can set colour correctly from a properly formed hex colour string" do
        @col.set_colour(TEST_HEX_COLOUR)
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)
      end

      it "can use uppercase hex" do
        @col.set_colour(TEST_HEX_COLOUR.upcase)
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

    describe "using colour= setter" do
      it "should handle an RGB array"  do
        @col.colour = [1, 2, 3]
        col_should_eql(@col, 1, 2, 3)
      end

      it "should handle a HEX string" do
        @col.colour = TEST_HEX_COLOUR
        col_should_eql(@col, TEST_RED, TEST_GREEN, TEST_BLUE)
      end

    end

  end

  describe "setters" do
    before(:each) do
      @col = ColourObj::Colour.new
    end

    it "should limit colour setter input to 0..255" do
      @col.red = 500
      @col.red.should eql 255

      @col.green = -500
      @col.green.should eql 0

      @col.blue = 256
      @col.blue.should eql 255

    end
  end

  describe "output" do
    before(:each) do
      @col = ColourObj::Colour.new
    end

    describe "in hex" do
      it "should correctly display as a 6 character, lower-case string" do
        @col.set_colour(TEST_HEX_COLOUR)
        @col.to_hex.should eql TEST_HEX_COLOUR
      end

      it "should respond to to_s in the same way as to_hex" do
        @col.set_colour(TEST_HEX_COLOUR)
        hex = @col.to_hex
        s = @col.to_s
        s.should eql hex

      end

      it "should correctly present component values < 0x10 in hex mode" do
        @col.set_colour("010c0f")
        @col.to_hex.should eql "010c0f"
      end
    end

    describe "in rgb" do
      it "should correctly return a 3-value int array representing R, G and B" do
        arr = [1,2,3]
        @col.set_colour(arr)
        @col.to_rgb.should eql arr
      end

      it "should respond to to_a in the same way as to_rgb" do
        arr = [1,2,3]
        @col.set_colour(arr)
        rgb = @col.to_rgb
        out_arr = @col.to_a
        out_arr.should eql rgb
      end
    end
  end


  describe "manipulating data" do
    before(:each) do
      @col = ColourObj::Colour.new
    end
    before(:all) do
      TEST_SHIFT_COL = [100, 100, 100]
    end

    describe "to change colours" do
      it "should be able to change each element by a given integer step" do
        @col.set_colour(TEST_SHIFT_COL)

        @col.shift red: 5
        @col.shift green: -10
        @col.shift blue: 0

        col_should_eql @col, TEST_SHIFT_COL[0]+5, TEST_SHIFT_COL[1]-10, TEST_SHIFT_COL[2]

      end

      it "should be able to change every element simultaneously by a given integer step" do
        @col.set_colour(TEST_SHIFT_COL)

        @col.shift all: 5
        @col.shift all: -10

        col_should_eql @col, TEST_SHIFT_COL[0]-5, TEST_SHIFT_COL[1]-5, TEST_SHIFT_COL[2]-5

      end

      it "should not exceed 0..255 for any single element" do
        @col.set_colour(TEST_SHIFT_COL)

        @col.shift red: 500
        @col.shift green: -500
        @col.shift blue: 256

        col_should_eql @col, 255,0,255

      end
      it "should not exceed 0..255 when set simultaneously" do
        @col.set_colour(TEST_SHIFT_COL)

        @col.shift all: 500
        col_should_eql @col, 255,255,255

      end
    end
  end

end

def col_should_eql(col, r, g, b)
  col.red.should eql r
  col.green.should eql g
  col.blue.should eql b
end
    