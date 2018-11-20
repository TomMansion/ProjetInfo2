local 
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

   % Translate a note to the extended notation.
   fun {NoteToExtended Note}
      case Note
      of Name#Octave then
         note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] Atom then
         case {AtomToString Atom}
         of [_] then
            note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
         [] [N O] then
            note(name:{StringToAtom [N]}
                 octave:{StringToInt [O]}
                 sharp:false
                 duration:1.0
                 instrument: none)
         end
      end
   end

   fun {ChordToExtended Chord}
       if(Chord.1 == nil) then nil
       else {NoteToExtended Chord.1}|{ChordToExtended Chord.2}
       end
   end

 
   fun {IsExtended Chord}
      case Chord of
	 H|T then case H of
		     silence(duration:Duration) then {IsExtended Chord.2}
		  [] note(name:Name octave:Octave sharp:Sharp duration:Duration instrument:Instrument) then {IsExtended Chord.2}
		  end
      [] nil then true
      end
   end
  
   
   
		     
   fun {ExtendAll Partition}
      case Partition of 
	 H|T then case H of %Basic check to ensure that we're working with a list
		      Name#Octave then {NoteToExtended H}|{ExtendAll T} %Checks for a note
		  [] Atom then {NoteToExtended H}|{ExtendAll T} %Checks for a note
		  [] silence(duration:Duration) then H|{ExtendAll T} %Checks for a silence in extended form
		  [] note(name:Name octave:Octave sharp:Sharp duration:Duration instrument:Instrument) then H|{ExtendAll T} %Checks for a note in extended form
		  [] A|B then
		     if({IsExtended H}) then
			H|{ExtendAll T}
		     else
			{ChordToExtended H}|{ExtendAll T}
		     end
		  else
		     H|{ExtendAll T} %handles transformations 
		  end
      [] nil then nil
      end
   end
 

   %@pre : Partition is already fully extended
   %@post : stretches all the notes and chords of this partition to play Factor times longer
   fun {Stretch Factor Partition}
      case Partition of
	 H|T then case H of
		     note(name:Name octave:Octave sharp:Sharp duration:Duration instrument:Instrument) then
		     newNote(name:note.1 octave:note.2 sharp:note.3 duration:note.4*Factor instrument:note.5)|{Stretch Factor T}
		  [] A|B then {Stretch Factor H}|{Stretch Factor T}
		  else H|{Stretch Factor T}
		  end
      [] nil then nil
      end
   end
   
		     
		     
		     
		     
      
      
   
   
  

   fun {PartitionToTimedList Partition}
      % TODO
      nil
   end

   

   fun {Mix P2T Music}
      % TODO
      {Project.readFile 'wave/animaux/cow.wav'}
   end

   

   Music = {Project.load 'joy.dj.oz'}
   Start

   % Uncomment next line to insert your tests.
   % \insert 'tests.oz'
   % !!! Remove this before submitting.
in
   Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
   {ForAll [NoteToExtended Music] Wait}
   
   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.
   {Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}
   
   % Shows the total time to run your code.
   {Browse {IntToFloat {Time}-Start} / 1000.0}
end