module ColourObj

  class Colour

    COLOUR_MIN = 0
    COLOUR_MAX = 255

    attr_reader :red, :green, :blue


    def initialize (colour = nil)
      @red, @green, @blue = 0, 0, 0

      set_colour colour
    end


    #SETTERS
    def set_colour (colour)
      return if colour.nil?
      parse! colour
    end

    def colour= (colour)
      set_colour(colour)
    end

    def red=(val)
      @red = bound(val)
    end

    def green=(val)
      @green = bound(val)
    end

    def blue=(val)
      @blue = bound(val)
    end

    def shift(hash)
      unless hash[:all].nil?
        hash[:red] = hash[:red].nil? ? hash[:all] : hash[:red] + hash[:all]
        hash[:green] = hash[:green].nil? ? hash[:all] : hash[:green] + hash[:all]
        hash[:blue] = hash[:blue].nil? ? hash[:all] : hash[:blue] + hash[:all]
      end


      _shift_red hash[:red] unless hash[:red].nil?
      _shift_green hash[:green] unless hash[:green].nil?
      _shift_blue hash[:blue] unless hash[:blue].nil?


    end


#returns an array of colours
    def to_rgb
      [@red, @green, @blue]
    end

    def to_s
      to_hex
    end

    def to_a
      to_rgb
    end

    def to_hex
      res = el_to_hex(@red) << el_to_hex(@green) << el_to_hex(@blue)
    end

    private

    def _shift_red(val)
      self.red= red + val
    end

    def _shift_green(val)
      self.green= green + val
    end

    def _shift_blue(val)
      self.blue= blue + val
    end

    def bound(val)
      [[val, COLOUR_MIN].max, COLOUR_MAX].min
    end

    def parse!(param)

      if param.is_a? Array

        validate_triplet! param
        set_rgb param

      elsif param.is_a? String
        hex_str = clean_hex param
        validate_hex! hex_str
        set_hex hex_str
      else
        raise ArgumentError, "Parameter must be either Array or String"
      end

    end

    def clean_hex(unclean_str)
      clean_str = unclean_str.downcase.gsub(/[^A-Za-z0-9]/, '')
    end

# Takes in a string of form RRGGBB where each character is 0..F
    def set_hex(clean_hex_str)
      @red = clean_hex_str[0, 2].to_i(16)
      @green = clean_hex_str[2, 2].to_i(16)
      @blue = clean_hex_str[4, 2].to_i(16)
    end

    def set_rgb(arr)
      @red, @green, @blue = arr.map do |el|
        bound(el)
      end
    end

    def el_to_hex(el)
      hx = el.to_s(16)
      if hx.length.eql? 1
        hx = "0" << hx
      end
      hx
    end


    def validate_triplet!(param)
      arr = param.to_a # Raises TypeError if cannot be converted / not already an array
      raise ArgumentError, "RGB Array must contain exactly 3 values" unless arr.length.eql?(3)
      arr.each do |el|
        raise TypeError, "Array element #{el} not an Integer" unless el.is_a? Integer
      end

    end


    def validate_hex!(str)

      raise TypeError, "Hex Value must be a string!" unless str.is_a? String
      raise ArgumentError, "Hex RGB must be exactly 6 characters" unless str.length.eql? 6
      raise ArgumentError, "Hex RGB string not valid hex string" unless (str.upcase =~ /^[A-F0-9]{6}$/).eql? 0

    end

  end
end