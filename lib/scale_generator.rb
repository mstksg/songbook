# Module providing a generator to generate a scale based on a given key and color/accidental 
# pattern. Implementation is based on music theory.
#
# Main relevant method is `ScaleGenerator::generate_scale(song_key,color)`
# 
# @author Justin Le
# 
module ScaleGenerator
  
  # All of the natural, or white notes.  The major scale is created by rotating the array until
  # its roote note is in the first position, and then modifying each index with "accidentals".
  NATURALS = %w[ A B C D E F G ].map { |n| n.intern }
  
  # Gives the order of keys in the Circle of Fifths in the given color.  A key's index on the
  # array is the number of accidentals that must be added to the Naturals to get the major scale.
  #
  # There are two ways to represent each key: As "sharpenings" of the major scale and as 
  # "flattenings" of it.  Pick one color to represent the key.
  CIRCLE_OF_FIFTHS =  { :flat  => (0..11).map { |n| (3 - 7*n) % 12 },
                        :sharp => (0..11).map { |n| (3 + 7*n) % 12 } }
  
  # Gives the actual position of the accidentals in the major scale.  If there are `n` accidentals
  # in the major scale, the major scale will have all of the listed accidentals up up til `n-1`.
  ACCIDENTALS = { :flat  => (0..11).map { |n| (3 + n*4) % 7 },
                  :sharp => (0..11).map { |n| (6 + n*3) % 7 } }
  
  # Flats are represented in the array of scale accidentals by negative numbers.
  # Sharps are represented by positive numbers.
  COLOR_VALUE  = {  :flat  => -1,
                    :sharp =>  1 }
  
  # The corresponding string for each accidental, to attach to the end of a note.
  COLOR_STRING = {  :flat  => "b",
                    :sharp => "#" }
  
  NATURALS.freeze
  
  # The shift from the tonic each mode is
  MODE_SHIFT = { :major       =>   0,
                 :minor       =>  -9,
                 :ionian      =>   0,
                 :dorian      =>  -2,
                 :phrygian    =>  -4,
                 :lydian      =>  -5,
                 :mixolydian  =>  -7,
                 :aeolian     =>  -9,
                 :locrian     => -11 }
  
  # Generates the scale for a given key and given color.
  # 
  # @param [SongKey] song_key
  #   A SongKey instance to render the scale into.
  # @param [Symbol] color
  #   `:sharp` or `:flat` -- the accidental mode/color to render the scale into.
  # @param [Symbol] mode
  #   The seven modern musical modes.  `:major` and `:minor` can be used as shorthand for `:ionian` 
  #   and `:aeolian`, respectively.
  # @return [Array<Symbol>]
  #   An array with the symbol of the absolute note value for each step.
  #
  def ScaleGenerator.generate_scale(song_key, color = :flat, mode = :major)
    if MODE_SHIFT[mode] == 0
      
      # initialize array of accidentals
      scale_accidentals = Array.new(7) { 0 }
      
      # get the id of the "natural" of the key, clean of accidentals.
      root_natural = song_key.symbol(ColorScheme.get_scheme_all(color)).to_s[0].intern
      natural_id = NATURALS.index(root_natural)
      
      # populate the array of accidentals
      number_of_accidentals = CIRCLE_OF_FIFTHS[color].index(song_key.key_id)
      number_of_accidentals.times { |n| scale_accidentals[ACCIDENTALS[color][n]] += COLOR_VALUE[color] }
      
      # make sure there aren't too many accidentals
      raise "Something is wrong with this scale." if scale_accidentals.any? { |n| n.abs > 3 }
      
      # map scale accidentals to actual scale, by steps
      return (0..6).map { |step| "#{NATURALS[(natural_id + step) % 7]}#{COLOR_STRING[color] * scale_accidentals[step].abs}".intern }
      
    else
      
      scale = ScaleGenerator.generate_scale(song_key.transpose(MODE_SHIFT[mode]),color,:major)
      
      # magical math function that gets the interval-1 of a mode from the given pitch shift
      # only works up to 11, but that's all we need, isn't it?
      steps = (MODE_SHIFT[mode].abs+1)/2
      
      # rotate the scale by the number of steps
      return scale[steps..-1] + scale[0..(steps-1)]
      
    end
  end
  
end