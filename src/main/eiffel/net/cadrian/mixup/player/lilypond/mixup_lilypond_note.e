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
   valid_reference: BOOLEAN
      do
         Result := not reference.is_rest
      end

   reference: MIXUP_NOTE_HEAD

feature {MIXUP_CHORD}
   visit_chord (a_chord: MIXUP_CHORD)
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
         if a_chord.tie then
            buffer.extend('~')
         end
         if a_chord.valid_anchor then
            reference := a_chord.anchor
         end
      end

feature {}
   append_note_head (note: MIXUP_NOTE_HEAD)
      local
         octave_shift: INTEGER
      do
         buffer.append(note.note.out)
         if not note.is_rest then
            octave_shift := anchor.octave_shift(note)
            if octave_shift < 0 then
               from
               until
                  octave_shift = 0
               loop
                  buffer.extend(',')
                  octave_shift := octave_shift + 1
               end
            elseif octave_shift > 0 then
               from
               until
                  octave_shift = 0
               loop
                  buffer.extend('%'')
                  octave_shift := octave_shift - 1
               end
            end
            anchor := note
         end
      end

   append_duration (duration: INTEGER_64)
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
   visit_lyrics (a_lyrics: MIXUP_LYRICS)
      do
         a_lyrics.note.accept(Current)
         lyrics_gatherer.call([a_lyrics, start_time])
      end

feature {ANY}
   generate (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION)
      do
         section.set_body(once " ")
         section.set_body(buffer)
      end

   can_append: BOOLEAN is True

   append_first, append_last (a_string: ABSTRACT_STRING)
      do
         buffer.append(a_string)
      end

feature {}
   make (a_start_time: like start_time; a_note: MIXUP_NOTE; a_reference: like reference; a_lyrics_gatherer: like lyrics_gatherer)
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
      ensure
         start_time = a_start_time
         a_note.valid_anchor implies reference = a_note.anchor
         not a_note.valid_anchor implies reference = a_reference
         lyrics_gatherer = a_lyrics_gatherer
      end

   start_time: INTEGER_64
   anchor: MIXUP_NOTE_HEAD
   buffer: STRING
   lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]

invariant
   lyrics_gatherer /= Void
   buffer /= Void
   not reference.is_rest
   not anchor.is_rest

end -- class MIXUP_LILYPOND_NOTE
