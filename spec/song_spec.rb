require "#{File.dirname(__FILE__)}/spec_helper"

describe 'song' do
  
  before(:each) do
    
    @structure = [ { :type => "INTRO" },
                   { :type => "VERSE", :lyric_variation => 1 },
                   { :type => "PRECHORUS" },
                   { :type => "CHORUS" },
                   { :type => "VERSE", :lyric_variation => 2 },
                   { :type => "PRECHORUS" },
                   { :type => "CHORUS", :repeat => 2 },
                   { :type => "BRIDGE", :repeat => 3 },
                   { :type => "CHORUS", :repeat => 2, :modulation => 2 } ]
    
    @bbyn = Song.create( :title => 'Blessed Be Your Name', :song_key => SongKey.KEY( :Bb ), :structure => @structure, :artist => "Matt Redman" )
    
    prog_1 = ChordProgression.first_or_create(:progression => [:I,:V,:vi,:IV] )
    prog_2 = ChordProgression.first_or_create(:progression => [:I,:V,:IV,:IV] )
    prog_3 = ChordProgression.first_or_create(:progression => [:I,:I,:V,:V,:vi,:V,:IV,:IV] )
    
    @intro      = Section.build( :type => "INTRO", :progressions => [prog_1,prog_1,prog_1,prog_2], :song => @bbyn )
    @verse      = Section.build( :type => "VERSE", :progressions => [prog_1,prog_2] * 2, :song => @bbyn )
    @prechorus  = Section.build( :type => "PRECHORUS", :progressions => [prog_1,prog_1], :song => @bbyn )
    @chorus     = Section.build( :type => "CHORUS", :progressions => [prog_1,prog_3], :song => @bbyn )
    @bridge     = Section.build( :type => "BRIDGE", :progressions => [prog_1,prog_1], :song => @bbyn )
    
    verse_1_text = <<VERSE
 
 Blessed be
 Your name, in the
land that is
plentiful

Where Your
streams of a-
bundance flow, blessed be Your name

 
 Blessed be
 Your name, when I'm
found in the de-
sert place

Though I
walk through the wild-
erness, blessed be Your name
VERSE

    verse_2_text = <<VERSE
 
 Blessed be
 Your name, when the
sun's shining down
on me

When the world's
"all as it
should be", blessed be Your name

 
 Blessed be
 Your name, on the
road marked with suf-
fering

Though there's pain
in the of-
fering, blessed be Your name
VERSE

    prechorus_text = <<PRECHORUS
 
 Every blessing
you pour out I'll
 turn back to
praise

 
 When the darkness
closes in, Lord,
 still I will say
PRECHORUS
    
    chorus_text = <<CHORUS
Blessed be the
name of the
Lord, Blessed be your
name

Blessed be the
name of the
Lord, Blessed be your
Glo-
rious
name
CHORUS
    
    bridge_text = <<BRIDGE
You
give and take a-
way, you
give and take a-
way

My
heart will choose to
say, "Lord,
blessed be your
name"
BRIDGE
    
    Lyric.build( verse_1_text, @verse, 1 )
    Lyric.build( verse_2_text, @verse, 2 )
    Lyric.build( prechorus_text, @prechorus )
    Lyric.build( chorus_text, @chorus )
    Lyric.build( bridge_text, @bridge )
    
    
    @rendered_sections = @bbyn.render_sections
  end
  
  specify 'intro renders properly' do
    rendered = @rendered_sections[0]
    
    rendered[:title].should == "INTRO"
    rendered[:instrumental].should == true
    rendered[:is_repeat].should == false
    rendered[:repeats].should == 1
    rendered[:lines][0][:chords].should == [:Bb,:F,:Gm,:Eb]
    rendered[:lines][0][:repeat].should == 3
    rendered[:lines][1][:chords].should == [:Bb,:F,:Eb]
    rendered[:lines][1][:repeat].should == 1
  end
  
  specify 'verse 1 renders properly' do
    rendered = @rendered_sections[1]
    
    rendered[:title].should == "VERSE 1"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == false
    rendered[:repeats].should == 1
    rendered[:lines][0][:chords].should == [:Bb,:F,:Gm,:Eb]
    rendered[:lines][1][:chords].should == [:'',:Bb,:F,:Eb]
  end
  
  specify 'prechorus 1 renders properly' do
    rendered = @rendered_sections[2]
    
    rendered[:title].should == "PRECHORUS"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == false
    rendered[:repeats].should == 1
    rendered[:lines][0][:chords].should == [:Bb,:F,:Gm,:Eb]
    rendered[:lines][1][:chords].should == [:Bb,:F,:Gm,:Eb]
  end
  
  specify 'chorus 1 renders properly' do
    rendered = @rendered_sections[3]
    
    rendered[:title].should == "CHORUS"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == false
    rendered[:repeats].should == 1
    rendered[:lines][0][:chords].should == [:'',:Bb,:F,:Gm,:Eb]
    rendered[:lines][1][:chords].should == [:'',:Bb,:F,:Gm,:F,:Eb]
  end
  
  specify 'verse 2 renders properly' do
    rendered = @rendered_sections[4]
    
    rendered[:title].should == "VERSE 2"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == false
    rendered[:repeats].should == 1
    rendered[:lines][0][:chords].should == [:Bb,:F,:Gm,:Eb]
    rendered[:lines][1][:chords].should == [:'',:Bb,:F,:Eb]
  end
  
  specify 'prechorus 2 renders properly' do
    rendered = @rendered_sections[5]
    
    rendered[:title].should == "PRECHORUS"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == true
    rendered[:repeats].should == 1
  end
  
  specify 'chorus 2 renders properly' do
    rendered = @rendered_sections[6]
    
    rendered[:title].should == "CHORUS"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == true
    rendered[:repeats].should == 2
  end
  
  specify 'bridge renders properly' do
    rendered = @rendered_sections[7]
    
    rendered[:title].should == "BRIDGE"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == false
    rendered[:repeats].should == 3
    rendered[:lines][0][:chords].should == [:'',:Bb,:F,:Gm,:Eb]
    rendered[:lines][1][:chords].should == [:'',:Bb,:F,:Gm,:Eb]
  end
  
  specify 'chorus 3 renders properly' do
    rendered = @rendered_sections[8]
    
    rendered[:title].should == "CHORUS"
    rendered[:instrumental].should == false
    rendered[:is_repeat].should == false
    rendered[:repeats].should == 2
    rendered[:lines][0][:chords].should == [:'',:C,:G,:Am,:F]
    rendered[:lines][1][:chords].should == [:'',:C,:G,:Am,:G,:F]
  end
  
  # TODO Spec this out more lol
  specify 'render_data should work right' do
    data = @bbyn.render_data
    
    data[:info][:title].should == "Blessed Be Your Name"
    data[:info][:artist].should == "Matt Redman"
    
  end
  
end