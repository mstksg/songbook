# Represents a Chord Progression, the smallest cohesive unit that songs are built up of,
# stored in the database and represented as an array of chord symbols.  Chord progressions
# are universal objects -- entities shared amongst sections and songs.
# 
# Chord Progressions are stored relative to the key the song or section is in.  As such, they
# are tasked with the duty of being displayed either in relative form (as roman numerals) or,
# more often, in the context of a given key (with the appropriate "coloration" -- see SongKey).
# 
# Even though chords are represented as an array of chord symbols, for rendering purposes, they
# are manipulated as instances of the Chord helper class.
# 
# @author Justin Le
# 
class ChordProgression
  
  # Render the ChordProgression to the given key and color scheme.
  # 
  # @param [SongKey] song_key
  #   SongKey of the key to render the chord progression into.
  # @param [ColorScheme] color_scheme
  #   ColorScheme to follow.  See ColorScheme for more info.  Optional (defaults to the default 
  #   color scheme)
  # @return [Array<Symbol>]
  #   Array of absolute_chord symbols corresponding to the stored progression
  #   rendered to the given SongKey and given ColorScheme.
  # 
  def render_into(song_key,color_scheme = ColorScheme.get('default'))
    chords_array.map { |c| c.render_into(song_key,color_scheme) }
  end
  
  # The length, in chords, of the chord progression.
  #
  # @return [Integer]
  #   The length of the chord progression.
  # 
  def length
    progression.length
  end
  
  private
  
  # Access the array of Chord instances corresponding with the array of chord_symbols stored in the
  #   database.
  #
  # @return [Array<Chord>]
  #   Array of Chord instances corresponding with the array of chord_symbols
  #   stored in the database.
  # 
  def chords_array
    @chords_array = progression.map { |c| Chord.CHORD(c) } unless @chords_array
    @chords_array
  end
  
end