local A B C D E F G H
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




fun {AccordToExtended J}
   case J of nil then nil
   elsecase J of label(arg1: a arg2:b) then
	if J.label == duration then {Duration a {AccordToExtended b}}
	 elseif J.label == stretch then {Stretch a {AccordToExtended b}}
	 elseif J.label == drone then {Drone a {AccordToExtended b}}
	 else {Transpose a {AccordToExtended b}}
	 end   	
   elsecase J of I|U then
      case I of label(1:a 2:b 3:c 4:d 5:e)then
	 I|{AccordToExtended U}
      else
	 {NoteToExtended I}|{AccordToExtended U}

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






fun{Duration X Y}
   nil
end


fun{Transpose Semitones Partition}
   nil
end


fun{Stretch Factor Partition}
   case Partition of
      H|T then
      case H of
	 note(name:Name octave:Octave sharp:Sharp duration:Duration instrument:Instrument) then
	 newNote(name:Name octave:Octave sharp:Sharp duration:Duration*Factor instrument:Instrument)|{Stretch Factor T}
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
   A = note(name:'b' octave:5 sharp:true duration:1.0 instrument:none)
   B = note(name:'b' octave:5 sharp:true duration:1.0 instrument:none)
   C = note(name:'b' octave:5 sharp:true duration:1.0 instrument:none)
   D = note(name:'b' octave:5 sharp:true duration:1.0 instrument:none)
   E = note(name:'b' octave:5 sharp:true duration:1.0 instrument:none)

   F = [A B C]
   G = [B C E F]
   H = [A C]
   {Browse [A B C D F E H G]}
   {Browse {Stretch 5.0 [A B C D F E H G]}}
end

