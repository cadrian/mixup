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

inherit
   MIXUP_ABSTRACT_STAFF[MIXUP_LILYPOND_OUTPUT,
                        MIXUP_LILYPOND_SECTION,
                        MIXUP_LILYPOND_ITEM,
                        MIXUP_LILYPOND_VOICE,
                        MIXUP_LILYPOND_VOICES]
      rename
         make as make_abstract
      redefine
         generate
      end

insert
   MIXUP_LILYPOND_CONTEXT

create {ANY}
   make

feature {ANY}
   instrument: MIXUP_LILYPOND_INSTRUMENT

feature {MIXUP_LILYPOND_INSTRUMENT}
   string_event (a_voice_id: INTEGER; a_string: FIXED_STRING)
      require
         a_string /= Void
      do
         voice(a_voice_id).string_event(a_string)
      end

feature {MIXUP_ABSTRACT_INSTRUMENT}
   generate (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION; generate_names: BOOLEAN)
      local
         iter_lyrics: ZIP[AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64], INTEGER]
         relative: FIXED_STRING
      do
         section.set_body(once "\new ")
         section.set_body(context_name)
         section.set_body(once " = %"")
         section.set_body(instrument.name)
         section.set_body(id.out)
         section.set_body(once "%" <<%N")
         if generate_names then
            generate_context(context, section, instrument)
         end
         section.set_body(once "\new Voice = %"")
         section.set_body(instrument.name)
         section.set_body(id.out)
         section.set_body(once "voice%" {%N")
         if root_voices /= Void then
            relative := get_string(context, lilypond_relative, Void)
            if relative /= Void then
               section.set_body(once "\relative ")
               section.set_body(relative)
               section.set_body(once " {%N")
               root_voices.generate(context, section)
               section.set_body(once "}%N")
            else
               root_voices.generate(context, section)
            end
         end
         section.set_body(once "}%N")

         if not lyrics.is_empty then
            create iter_lyrics.make(lyrics, 1 |..| lyrics.count)
            iter_lyrics.do_all(agent generate_lyrics(?, ?, context, section))
         end

         section.set_body(once ">>%N")
      end

feature {}
   lilypond_relative: FIXED_STRING
      once
         Result := "lilypond.relative".intern
      end

   generate_lyrics (lyr: AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]; index: INTEGER; context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION)
      do
         if index \\ 2 = 0 then
            section.set_body(once "\new AltLyrics = %"")
         else
            section.set_body(once "\new Lyrics = %"")
         end
         section.set_body(instrument.name)
         section.set_body(id.out)
         section.set_body(once "x")
         section.set_body(index.out)
         section.set_body(once "%" \lyricsto %"")
         section.set_body(instrument.name)
         section.set_body(id.out)
         section.set_body(once "voice%" {%N")
         section.set_body(once "\lyricmode {%N")
         lyr.do_all_items(agent (a_syllable: MIXUP_SYLLABLE; a_section: MIXUP_LILYPOND_SECTION)
                             do
                                a_section.set_body(once " ")
                                if a_syllable.in_word then
                                   a_section.set_body(once "-- ")
                                end
                                a_section.set_body(once "%"")
                                a_section.set_body(a_syllable.syllable)
                                a_section.set_body(once "%"")
                             end(?, section))
         section.set_body(once "%N}%N}%N")
      end

feature {}
   make (a_instrument: like instrument; a_id: like id; a_voice_ids: TRAVERSABLE[INTEGER]; a_reference: like reference)
      require
         a_instrument /= Void
         a_id > 0
      do
         make_abstract(a_id, a_voice_ids)
         reference := a_reference
         instrument := a_instrument
      ensure
         reference = a_reference
         instrument = a_instrument
      end

   context_name: FIXED_STRING
      once
         Result := "Staff".intern
      end

   reference: MIXUP_NOTE_HEAD

   new_voices (a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]): like root_voices
      local
         voice_: like voice
         ref: like reference
      do
         if paths.is_empty then
            ref := reference
         else
            voice_ := voice(a_voice_id)
            if voice_.valid_reference then
               ref := voice_.reference
               log.info.put_line("Lilypond: Voice #" + a_voice_id.out + " (instrument " + instrument.name.out + "): giving reference " + ref.out + " to voices " + voice_ids.out)
            else
               log.warning.put_line("Lilypond: Voice #" + a_voice_id.out + " (instrument " + instrument.name.out + "): no valid reference")
               ref := reference
            end
         end
         create Result.make(voice_ids, ref, lyrics_gatherer)
      end

invariant
   instrument /= Void
   id > 0
   lyrics /= Void
   voices /= Void
   paths /= Void
   voices.count = paths.count

end -- class MIXUP_LILYPOND_STAFF
