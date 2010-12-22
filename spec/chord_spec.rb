require "#{File.dirname(__FILE__)}/spec_helper"

describe 'chord' do
  
  before(:each) do
    @major_chord = Chord.CHORD(:IV)
    @minor_chord = Chord.CHORD(:vi)
  end
  
  specify 'Chord::CHORD should return a Chord instance' do
    @major_chord.class.should == Chord
  end
  
  specify 'major chord should have a symbol of :IV' do
    @major_chord.symbol.should == :IV
  end

  specify 'minor chord should have a symbol of :vi' do
    @minor_chord.symbol.should == :vi
  end
  
  specify 'major chord should render as :Eb in Bb Major' do
    @major_chord.render_into( SongKey.KEY(:Bb) ).should == :Eb
  end
  
  specify 'minor chord should render as :"F#m" in A Major' do
    @minor_chord.render_into( SongKey.KEY(:A) ).should == "F#m".intern
  end
  
end