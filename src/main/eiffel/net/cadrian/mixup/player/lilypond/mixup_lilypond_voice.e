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
   MIXUP_ABSTRACT_VOICE[MIXUP_LILYPOND_OUTPUT, MIXUP_LILYPOND_SECTION, MIXUP_LILYPOND_ITEM]
      rename
         make as make_abstract
      redefine
         generate
      end

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   valid_reference: BOOLEAN is
      do
         Result := not reference.is_rest
      end

   reference: MIXUP_NOTE_HEAD

   can_append: BOOLEAN is
      do
         Result := items.exists(agent {MIXUP_LILYPOND_ITEM}.can_append)
      end

   append_first (a_string: ABSTRACT_STRING) is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := items.lower
         until
            found
         loop
            found := items.item(i).can_append
            if found then
               items.item(i).append_first(a_string)
            end
            i := i + 1
         end
      end

   append_last (a_string: ABSTRACT_STRING) is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := items.upper
         until
            found
         loop
            found := items.item(i).can_append
            if found then
               items.item(i).append_last(a_string)
            end
            i := i - 1
         end
      end

feature {MIXUP_ABSTRACT_STAFF}
   add_item (a_item: MIXUP_LILYPOND_ITEM) is
      do
         if dynamics /= Void then
            a_item.append_first(dynamics)
            dynamics := Void
         end
         if slur /= Void then
            a_item.append_first(slur)
            slur := Void
         end
         items.add_last(a_item)
         if a_item.valid_reference then
            check
               not a_item.reference.is_rest
            end
            reference := a_item.reference
            log.trace.put_line("Lilypond voice #" + id.out + ": anchor = " + reference.out)
         end
      end

   set_dynamics (a_dynamics, position: ABSTRACT_STRING) is
      do
         if position = Void then
            dynamics := "-\" + a_dynamics
         elseif a_dynamics.out.is_equal("end") then
            dynamics := "-\!"
         else
            inspect
               position.out
            when "up" then
               dynamics := "^\" + a_dynamics
            when "down" then
               dynamics := "_\" + a_dynamics
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
         create note.make(a_time, a_note, reference, lyrics_gatherer)
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
         slur := once "("
      end

   end_slur is
      do
         append_last(once ")")
      end

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         slur := once "\("
      end

   end_phrasing_slur is
      do
         append_last(once "\)")
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

feature {MIXUP_ABSTRACT_VOICES}
   generate (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION) is
      do
         items.do_all(agent {MIXUP_LILYPOND_ITEM}.generate(context, section))
         section.set_body(once "%N")
      end

feature {}
   make (a_id: like id; a_reference: like reference; a_lyrics_gatherer: like lyrics_gatherer) is
      do
         make_abstract(a_id, a_lyrics_gatherer)
         if not a_reference.is_rest then
            reference := a_reference
         end
      end

   dynamics: STRING
   slur: STRING

end -- class MIXUP_LILYPOND_VOICE
