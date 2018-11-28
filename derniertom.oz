local A B C D E F G H
fun {NoteToExtended Note}
     case Note
     of Name#Octave then
	note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
     [] silence(duration:Duration) then
	silence(duration:Note.duration)
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




%fun {AccordToExtended J}
 %  case J of nil then nil
  % elsecase J of label(arg1: a arg2:b) then
%	if J.label == duration then {Duration a {AccordToExtended b}}
%	 elseif {Record.label J} == stretch then {Stretch a {AccordToExtended b}}
%	 elseif J.label == drone then {Drone a {AccordToExtended b}}
%	 else {Transpose a {AccordToExtended b}}
%	 end   	
 %  elsecase J of I|U then
  %    case I of label(1:a 2:b 3:c 4:d 5:e)then
%	 I|{AccordToExtended U}
 %     else
%	 {NoteToExtended I}|{AccordToExtended U}
%
 %     end
  % end
%end

fun {AccordToExtended Partition}
   case Partition of
      nil then nil
   [] duration(duration:Duration Liste) then
      {Duration Duration {AccordToExtended Liste}}
   [] stretch(factor:Factor Liste) then
      {Stretch Factor {AccordToExtended Liste}}
   [] drone(note:Chord amount:Natural) then
      {Drone {AccordToExtended Chord} Natural}
   [] transpose(semitones:Integer Liste) then
      {Transpose Integer {AccordToExtended Liste}}
   [] H|T then
      case H of
	 note(name:Name octave:Octave sharp:Sharp duration:Duration instrument:Instrument) then
	 H|{AccordToExtended T}
      else
	 {NoteToExtended H}|{AccordToExtended T}
      end
   end
end



fun {PartitionToTimedList partition}
   case partition of nil then nil
   [] H|T then
      case H of label(arg1: x arg2: y) then
	 if H.label == duration then {Duration x {AccordToExtended y}}|{PartitionToTimedList T}
	 elseif H.label == stretch then {Stretch x {AccordToExtended y}}|{PartitionToTimedList T}
	 elseif H.label == drone then {Drone x {AccordToExtended y}}|{PartitionToTimedList T}
	 else {Transpose x {AccordToExtended y}}|{PartitionToTimedList T}
	 end
      [] H1|T1 then
	 case H1 of label(1:a 2:b 3:c 4:d 5:e)then
	    H1|{AccordToExtended T1}|{PartitionToTimedList T}
	 else
	    {NoteToExtended H1}|{AccordToExtended T1}|{PartitionToTimedList T}
	 end
      end
   end
end

fun {Timetot Part}
   local Time in
      fun{Time Parti V}
	 case Parti of H|T then
	    case H of H1|T1 then
	       {Time T V+H1.duration}
	    else
	       {Time T V+H.duration}
	    end
	 [] nil then V
	 end
      end
      {Time Part 0.0}
   end
end


fun{Duration Duree Partition}
   local R V in 
   R = {Timetot Partition}
   V = Duree/R
   {Stretch V Partition}
   end
end


fun{Transpose Semitones Partition}
   case Partition of
      H|T then
      case H of note(name:Name octave:Octave sharp:Sharp duration:Duration instrument:Instrument) then
	 {TransNote Semitones H}|{Transpose Semitones T}
      [] H1|T1 then
	 {Transpose Semitones H}|{Transpose Semitones T}
      [] nil then nil
      end
   [] nil then nil
   end	 
end

fun {TransNote Semitones Note} % Fonction pour transposer une note. Chaque note correspond à un entier de 1 à 12, la fonction calcule l'octave et la note résultante sur base de calculs div et mod.
   if {And Note.name == c Note.sharp == false} then
      if (1+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (1+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      end
   elseif {And Note.name == c Note.sharp} then
         if (2+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (2+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == d Note.sharp == false} then
         if (3+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (3+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == d Note.sharp} then
         if (4+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (4+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == e Note.sharp == false} then
         if (5+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (5+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == f Note.sharp == false} then
         if (6+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (6+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == f Note.sharp} then
         if (7+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (7+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == g Note.sharp == false} then
         if (8+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (8+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == g Note.sharp} then
         if (9+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (9+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == a Note.sharp == false} then
         if (10+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (10+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == a Note.sharp} then
         if (11+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (11+Semitones mod 12) mod 12 == 12 then
	 note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   elseif {And Note.name == b Note.sharp == false} then
         if (12+Semitones mod 12) mod 12 == 1 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 2 then
	 note(name:c octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 3 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 4 then
	 note(name:d octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 5 then
	 note(name:e octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 6 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 7 then
	 note(name:f octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 8 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 9 then
	 note(name:g octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 10 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 11 then
	 note(name:a octave:(Note.octave + Semitones div 12) sharp:true duration:Note.duration instrument:Note.instrument)
      elseif (12+Semitones mod 12) mod 12 == 12 then
	    note(name:b octave:(Note.octave + Semitones div 12) sharp:false duration:Note.duration instrument:Note.instrument)
	 end
   end
end

   
	 
      
fun{Stretch Factor Partition}
   case Partition of
      H|T then
      case H of
	 note(name:Name octave:Octave sharp:Sharp duration:Duration instrument:Instrument) then
	 note(name:Name octave:Octave sharp:Sharp duration:Duration*Factor instrument:Instrument)|{Stretch Factor T}
      [] H1|T1 then
	 {Stretch Factor H}|{Stretch Factor T}
      else {Stretch Factor H}|{Stretch Factor T}
      end
   [] nil then nil
   else nil
   end
end


fun {Drone Note Amount}
   if Amount > 0 then
      Note|{Drone Note Amount-1}
   elseif Amount == 0 then
      nil
   end
end

in
   A = drone(note:H amount:5)
   B = c
   C = c#5
   D = d3
   E = e4

   F = [A B C stretch(factor:3.0 G)]
   G = [B C E]
   H = [E C]


   {Browse {AccordToExtended F}}
end

