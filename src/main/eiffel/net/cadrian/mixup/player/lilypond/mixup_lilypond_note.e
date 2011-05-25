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
class MIXUP_LILYPOND_NOTE

inherit
   MIXUP_LILYPOND_ITEM
   MIXUP_NOTE_VISITOR

insert
   MIXUP_NOTE_DURATIONS

create {ANY}
   make

feature {ANY}
   anchor: MIXUP_NOTE_HEAD

feature {MIXUP_CHORD}
   visit_chord (a_chord: MIXUP_CHORD) is
      local
         i: INTEGER
      do
         anchor := reference
         if a_chord.count = 1 then
            append_note_head(a_chord.first)
         else
            buffer.extend('<')
            from
               i := a_chord.lower
            until
               i > a_chord.upper
            loop
               if i > a_chord.lower then
                  buffer.extend(' ')
               end
               append_note_head(a_chord.item(i))
               i := i + 1
            end
            buffer.extend('>')
         end
         append_duration(a_chord.duration)
      end

feature {}
   append_note_head (note: MIXUP_NOTE_HEAD) is
      do
         buffer.append(note.note.out) -- TODO: octave skips
         if not note.is_rest then
            anchor := note
         end
      end

   append_duration (duration: INTEGER_64) is
      do
         inspect duration
         when duration_64   then buffer.append("64"  )
         when duration_64p  then buffer.append("64." )
         when duration_64pp then buffer.append("64..")
         when duration_32   then buffer.append("32"  )
         when duration_32p  then buffer.append("32." )
         when duration_32pp then buffer.append("32..")
         when duration_16   then buffer.append("16"  )
         when duration_16p  then buffer.append("16." )
         when duration_16pp then buffer.append("16..")
         when duration_8    then buffer.append("8"   )
         when duration_8p   then buffer.append("8."  )
         when duration_8pp  then buffer.append("8.." )
         when duration_4    then buffer.append("4"   )
         when duration_4p   then buffer.append("4."  )
         when duration_4pp  then buffer.append("4.." )
         when duration_2    then buffer.append("2"   )
         when duration_2p   then buffer.append("2."  )
         when duration_2pp  then buffer.append("2.." )
         when duration_1    then buffer.append("1"   )
         when duration_1p   then buffer.append("1."  )
         when duration_1pp  then buffer.append("1.." )
         end
      end

feature {MIXUP_LYRICS}
   visit_lyrics (a_lyrics: MIXUP_LYRICS) is
      do
         a_lyrics.note.accept(Current)
         lyrics_gatherer.call([a_lyrics, start_time])
      end

feature {ANY}
   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      do
         output.put_character(' ')
         output.put_string(buffer)
      end

feature {}
   make (a_dynamics: ABSTRACT_STRING; a_start_time: like start_time; a_note: MIXUP_NOTE; a_reference: like reference; a_lyrics_gatherer: like lyrics_gatherer) is
      require
         a_note /= Void
         a_lyrics_gatherer /= Void
         not a_reference.is_rest
      do
         start_time := a_start_time
         reference := a_reference
         lyrics_gatherer := a_lyrics_gatherer
         buffer := ""
         a_note.accept(Current)
         if a_dynamics /= Void then
            buffer.append(a_dynamics)
         end
      ensure
         start_time = a_start_time
         reference = a_reference
         lyrics_gatherer = a_lyrics_gatherer
      end

   start_time: INTEGER_64
   reference: MIXUP_NOTE_HEAD
   buffer: STRING
   lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]

invariant
   lyrics_gatherer /= Void
   buffer /= Void
   not reference.is_rest
   not anchor.is_rest

end -- class MIXUP_LILYPOND_NOTE
