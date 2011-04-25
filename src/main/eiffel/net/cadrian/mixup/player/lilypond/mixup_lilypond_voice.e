-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_LILYPOND_VOICE

inherit
   MIXUP_NOTE_VISITOR

insert
   MIXUP_NOTE_DURATIONS

create {ANY}
   make

feature {ANY}
   staff: MIXUP_LILYPOND_STAFF
   id: INTEGER

feature {MIXUP_LILYPOND_STAFF}
   set_dynamics (dynamics, position: ABSTRACT_STRING) is
      do
         if position = Void then
            last_dynamics := "-\" + dynamics
         elseif dynamics.out.is_equal("end") then
            last_dynamics := "-\!"
         else
            inspect
               position.out
            when "up" then
               last_dynamics := "^\" + dynamics
            when "down" then
               last_dynamics := "_\" + dynamics
            when "top" then
               not_yet_implemented
            when "bottom" then
               not_yet_implemented
            when "hidden" then
               -- nothing
            end
         end
      end

   set_note (note: MIXUP_NOTE) is
      do
         note.accept(Current)
         reference := note.anchor
      end

   next_bar (style: ABSTRACT_STRING) is
      do
         if style = Void then
            notes.append(" | ")
         else
            notes.append(" \bar %"" + style.out + "%"")
         end
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_beam is
      do
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_slur is
      do
      end

   start_tie (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_tie is
      do
      end

   start_repeat (volte: INTEGER_64) is
      do
      end

   end_repeat is
      do
      end

feature {MIXUP_CHORD}
   visit_chord (a_chord: MIXUP_CHORD) is
      local
         anchor: like reference
         i: INTEGER
      do
         anchor := reference
         if a_chord.count > 1 then
            notes.extend('<')
         end
         from
            i := a_chord.lower
         until
            i > a_chord.upper
         loop
            if i > a_chord.lower then
               notes.extend(' ')
            end
            append_note_head(anchor, a_chord.item(i))
            anchor := a_chord.item(i)
            i := i + 1
         end
         if a_chord.count > 1 then
            notes.extend('>')
         end
         append_duration(a_chord.duration)
      end

feature {}
   append_note_head (anchor, note: MIXUP_NOTE_HEAD) is
      do
         notes.extend(' ')
         notes.append(note.note.out) -- TODO: octave skips
      end

   append_duration (duration: INTEGER_64) is
      do
         inspect duration
         when duration_64   then notes.append("64"  )
         when duration_64p  then notes.append("64." )
         when duration_64pp then notes.append("64..")
         when duration_32   then notes.append("32"  )
         when duration_32p  then notes.append("32." )
         when duration_32pp then notes.append("32..")
         when duration_16   then notes.append("16"  )
         when duration_16p  then notes.append("16." )
         when duration_16pp then notes.append("16..")
         when duration_8    then notes.append("8"   )
         when duration_8p   then notes.append("8."  )
         when duration_8pp  then notes.append("8.." )
         when duration_4    then notes.append("4"   )
         when duration_4p   then notes.append("4."  )
         when duration_4pp  then notes.append("4.." )
         when duration_2    then notes.append("2"   )
         when duration_2p   then notes.append("2."  )
         when duration_2pp  then notes.append("2.." )
         when duration_1    then notes.append("1"   )
         when duration_1p   then notes.append("1."  )
         when duration_1pp  then notes.append("1.." )
         end
      end

feature {MIXUP_LYRICS}
   visit_lyrics (a_lyrics: MIXUP_LYRICS) is
      local
         zip: ZIP[STRING, FIXED_STRING]
      do
         a_lyrics.note.accept(Current)
         ensure_lyrics_count(a_lyrics.count)
         create zip.make(lyrics, a_lyrics)
         zip.do_all(agent (lyr: STRING; a_lyr: FIXED_STRING) is
                    do
                       lyr.extend(' ')
                       lyr.extend('"')
                       lyr.append(a_lyr)
                       lyr.extend('"')
                    end)
      end

feature {MIXUP_LILYPOND_STAFF}
   generate (output: OUTPUT_STREAM) is
      require
         output.is_connected
      local
         zip: ZIP[STRING, INTEGER]
      do
         output.put_line("            \new Voice = %"" + staff.instrument.name.out + staff.id.out + "v" + id.out + "%" {")
         output.put_line("               <<")
         output.put_line("                  " + notes)
         output.put_line("               >>")
         output.put_line("            }")
         if not lyrics.is_empty then
            create zip.make(lyrics, 1 |..| lyrics.count)
            zip.do_all(agent generate_lyrics(?, ?, output))
         end
      end

feature {}
   make (a_staff: like staff; a_id: like id; a_reference: like reference) is
      require
         a_staff /= Void
         a_id > 0
      do
         staff := a_staff
         id := a_id
         reference := a_reference
         notes := ""
         create lyrics.make(0)
      ensure
         staff = a_staff
         id = a_id
      end

   last_dynamics: STRING
   reference: MIXUP_NOTE_HEAD

   notes: STRING
   lyrics: FAST_ARRAY[STRING]

   ensure_lyrics_count (a_count: INTEGER) is
      do
         from
         until
            lyrics.count >= a_count
         loop
            lyrics.add_last("")
         end
      ensure
         lyrics.count >= a_count
      end

   generate_lyrics (lyr: STRING; index: INTEGER; output: OUTPUT_STREAM) is
      require
         lyr /= Void
         index > 0
         output.is_connected
      do
         if index \\ 2 = 0 then
            output.put_string("            \new AltLyrics = ")
         else
            output.put_string("            \new Lyrics = ")
         end
         output.put_line("%"" + staff.instrument.name.out + staff.id.out + "v" + id.out + "x" + index.out
                         + "%" \lyricsto %"" + staff.instrument.name.out + staff.id.out + "v" + id.out + "%" {")
         output.put_line("               " + lyr)
         output.put_line("            }")
      end

invariant
   staff /= Void
   lyrics /= Void
   lyrics.for_all(agent (l: STRING): BOOLEAN is do Result := l /= Void end)
   id > 0

end -- class MIXUP_LILYPOND_VOICE
