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
class MIXUP_LILYPOND_STAFF

insert
   MIXUP_LILYPOND_CONTEXT

create {ANY}
   make

feature {ANY}
   instrument: MIXUP_LILYPOND_INSTRUMENT
   id: INTEGER

feature {MIXUP_LILYPOND_INSTRUMENT}
   start_voices (a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]) is
      local
         map: AVL_DICTIONARY[MIXUP_LILYPOND_VOICE, INTEGER]
         v: like voices
      do
         create v.make(Current, voice_ids, reference, lyrics_gatherer)
         create map.make
         if voices = Void then
            check paths.is_empty end
            voices := v
         else
            check not paths.is_empty end
            map.copy(paths.top)
            voice(a_voice_id).add_item(v)
         end
         v.map_in(map)
         paths.push(map)
      end

   end_voices (a_voice_id: INTEGER) is
      do
         paths.pop
      end

   set_dynamics (a_voice_id: INTEGER; dynamics, position: ABSTRACT_STRING) is
      do
         voice(a_voice_id).set_dynamics(dynamics, position)
      end

   set_note (a_voice_id: INTEGER; time: INTEGER_64; note: MIXUP_NOTE) is
      do
         voice(a_voice_id).set_note(time, note)
      end

   next_bar (a_voice_id: INTEGER; style: ABSTRACT_STRING) is
      do
         voice(a_voice_id).next_bar(style)
      end

   start_beam (a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         voice(a_voice_id).start_beam(xuplet_numerator, xuplet_denominator, text)
      end

   end_beam (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_beam
      end

   start_slur (a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         voice(a_voice_id).start_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_slur (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_slur
      end

   start_phrasing_slur (a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         voice(a_voice_id).start_phrasing_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_phrasing_slur (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_phrasing_slur
      end

   start_repeat (a_voice_id: INTEGER; volte: INTEGER_64) is
      do
         voice(a_voice_id).start_repeat(volte)
      end

   end_repeat (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_repeat
      end

   string_event (a_voice_id: INTEGER; a_string: FIXED_STRING) is
      require
         a_string /= Void
      do
         voice(a_voice_id).string_event(a_string)
      end

feature {MIXUP_LILYPOND_INSTRUMENT}
   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM; generate_names: BOOLEAN) is
      require
         output.is_connected
      local
         iter_lyrics: ZIP[AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64], INTEGER]
      do
         output.put_string(once "\new ")
         output.put_string(context_name)
         output.put_string(once " = %"")
         output.put_string(instrument.name)
         output.put_integer(id)
         output.put_line(once "%" <<")
         if generate_names then
            generate_context(context, output, instrument)
         end
         output.put_string(once "\new Voice = %"")
         output.put_string(instrument.name)
         output.put_integer(id)
         output.put_line(once "voice%" {")
         if voices /= Void then
            voices.generate(context, output)
         end
         output.put_new_line
         output.put_line(once "}")

         if not lyrics.is_empty then
            create iter_lyrics.make(lyrics, 1 |..| lyrics.count)
            iter_lyrics.do_all(agent generate_lyrics(?, ?, context, output))
         end

         output.put_line(once ">>")
      end

feature {}
   gather_lyrics (a_lyrics: TRAVERSABLE[MIXUP_SYLLABLE]; a_time: INTEGER_64) is
      local
         zip: ZIP[AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64], MIXUP_SYLLABLE]
      do
         ensure_lyrics_count(a_lyrics.count)
         create zip.make(lyrics, a_lyrics)
         zip.do_all(agent {AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]}.put({MIXUP_SYLLABLE}, a_time))
      end

   ensure_lyrics_count (a_count: INTEGER) is
      do
         from
         until
            lyrics.count >= a_count
         loop
            lyrics.add_last(create {AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]}.make)
         end
      ensure
         lyrics.count >= a_count
      end

   generate_lyrics (lyr: AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]; index: INTEGER; context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      require
         lyr /= Void
         index > 0
         output.is_connected
      do
         if index \\ 2 = 0 then
            output.put_string(once "\new AltLyrics = ")
         else
            output.put_string(once "\new Lyrics = ")
         end
         output.put_character('"')
         output.put_string(instrument.name)
         output.put_integer(id)
         output.put_character('x')
         output.put_integer(index)
         output.put_string(once "%" \lyricsto %"")
         output.put_string(instrument.name)
         output.put_integer(id)
         output.put_line(once "voice%" {")
         output.put_line(once "\lyricmode {")
         lyr.do_all_items(agent (a_syllable: MIXUP_SYLLABLE; a_output: OUTPUT_STREAM) is
                             do
                                a_output.put_character(' ')
                                if a_syllable.in_word then
                                   a_output.put_string(once "-- ")
                                end
                                a_output.put_character('"')
                                a_output.put_string(a_syllable.syllable)
                                a_output.put_character('"')
                             end(?, output))
         output.put_new_line
         output.put_line(once "}")
         output.put_line(once "}")
      end

feature {}
   make (a_player: like player; a_instrument: like instrument; a_id: like id; a_voice_ids: TRAVERSABLE[INTEGER]; a_reference: like reference) is
      require
         a_player /= Void
         a_instrument /= Void
         a_id > 0
      do
         reference := a_reference
         player := a_player
         instrument := a_instrument
         id := a_id
         create lyrics.make(0)
         lyrics_gatherer := agent gather_lyrics
         create paths.make
      ensure
         reference = a_reference
         player = a_player
         instrument = a_instrument
         id = a_id
      end

   player: MIXUP_LILYPOND_PLAYER

   context_name: FIXED_STRING is
      once
         Result := "Staff".intern
      end

   reference: MIXUP_NOTE_HEAD
   lyrics: FAST_ARRAY[AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]]
   lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]

   voices: MIXUP_LILYPOND_VOICES
   paths: STACK[AVL_DICTIONARY[MIXUP_LILYPOND_VOICE, INTEGER]]

   voice (a_voice_id: INTEGER): MIXUP_LILYPOND_VOICE is
      require
         not paths.is_empty
      do
         Result := paths.top.reference_at(a_voice_id)
      end

invariant
   player /= Void
   instrument /= Void
   id > 0
   lyrics /= Void
   paths /= Void

end -- class MIXUP_LILYPOND_STAFF
