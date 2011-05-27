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

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   staff: MIXUP_LILYPOND_STAFF
   id: INTEGER

   valid_reference: BOOLEAN
   reference: MIXUP_NOTE_HEAD

feature {MIXUP_LILYPOND_STAFF}
   add_item (a_item: MIXUP_LILYPOND_ITEM) is
      require
         a_item /= Void
      do
         items.add_last(a_item)
         if a_item.valid_reference then
            valid_reference := True
            reference := a_item.reference
            log.trace.put_line("Lilypond voice #" + id.out + ": anchor = " + reference.out)
         end
      end

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

   set_note (a_time: INTEGER_64; a_note: MIXUP_NOTE) is
      local
         note: MIXUP_LILYPOND_NOTE
      do
         create note.make(last_dynamics, a_time, a_note, reference, lyrics_gatherer)
         last_dynamics := Void
         add_item(note)
      end

   next_bar (style: ABSTRACT_STRING) is
      local
         str: STRING
      do
         if style = Void then
            str := once " |"
         else
            str := " \bar %"" + style.out + "%""
         end
         add_item(create {MIXUP_LILYPOND_STRING}.make(str))
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

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_phrasing_slur is
      do
      end

   start_repeat (volte: INTEGER_64) is
      do
      end

   end_repeat is
      do
      end

   string_event (a_string: FIXED_STRING) is
      require
         a_string /= Void
      do
         add_item(create {MIXUP_LILYPOND_STRING}.make(a_string))
      end

feature {MIXUP_LILYPOND_VOICES}
   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      do
         items.do_all(agent {MIXUP_LILYPOND_ITEM}.generate(context, output))
         output.put_new_line
      end

feature {}
   make (a_staff: like staff; a_id: like id; a_reference: like reference; a_lyrics_gatherer: like lyrics_gatherer) is
      require
         a_staff /= Void
         a_id > 0
         a_lyrics_gatherer /= Void
      do
         staff := a_staff
         id := a_id
         reference := a_reference
         lyrics_gatherer := a_lyrics_gatherer
         create items.make(0)
      ensure
         staff = a_staff
         id = a_id
         lyrics_gatherer = a_lyrics_gatherer
      end

   items: FAST_ARRAY[MIXUP_LILYPOND_ITEM]
   lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]

   last_dynamics: STRING

invariant
   staff /= Void
   id > 0
   lyrics_gatherer /= Void
   items /= Void

end -- class MIXUP_LILYPOND_VOICE
