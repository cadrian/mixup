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
   MIXUP_LILYPOND_ITEM
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
   valid_reference: BOOLEAN
      do
         Result := not reference.is_rest
      end

   reference: MIXUP_NOTE_HEAD

   can_append: BOOLEAN
      do
         Result := items.exists(agent {MIXUP_LILYPOND_ITEM}.can_append)
      end

   append_first (a_string: ABSTRACT_STRING)
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

   append_last (a_string: ABSTRACT_STRING)
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
   add_item (a_item: MIXUP_LILYPOND_ITEM)
      do
         if a_item.can_append then
            if dynamics /= Void then
               if dynamics_is_open then
                  close_dynamics
               end
               a_item.append_first(dynamics)
               dynamics := Void
            end
            if slur /= Void then
               a_item.append_first(slur)
               slur := Void
            end
         end
         items.add_last(a_item)
         if a_item.valid_reference then
            check
               not a_item.reference.is_rest
            end
            reference := a_item.reference
            log.trace.put_line(once "Lilypond voice #" | &id | once ": anchor = " | &reference)
         end
      end

   set_dynamics (a_dynamics, position: ABSTRACT_STRING; is_standard: BOOLEAN)
      do
         if (position /= Void and then (dynamics_position /= position.intern)) or else (position = Void and then dynamics_position /= Void) then
            if dynamics_is_open then
               close_dynamics
            end
            if position = Void then
               dynamics_position := Void
            else
               dynamics_position := position.intern
            end
         end

         if a_dynamics.out.is_equal("end") then
            if dynamics_is_open then
               close_dynamics
               dynamics.append(once "-\!")
            else
               if dynamics = Void then
                  dynamics := ""
               end
               dynamics.append(once "-\!")
            end
         else
            inspect
               a_dynamics.intern
            when "<", ">" then
               if dynamics_is_open then
                  close_dynamics
               elseif dynamics = Void then
                  dynamics := ""
               end
               dyn_position(position)
               if not dynamics_is_hidden then
                  dynamics.extend('\')
                  dynamics.append(a_dynamics)
               end
            else
               if not dynamics_is_open then
                  if dynamics = Void then
                     dynamics := ""
                  end
                  open_dynamics(position)
               elseif not dynamics_is_hidden then
                  dynamics.extend(' ')
               end
               if not dynamics_is_hidden then
                  dynamics.append(dyn_markup(a_dynamics, is_standard))
               end
            end
         end
      end

   set_note (a_time: INTEGER_64; a_note: MIXUP_NOTE)
      local
         note: MIXUP_LILYPOND_NOTE
      do
         create note.make(a_time, a_note, reference, lyrics_gatherer)
         add_item(note)
      end

   next_bar (style: ABSTRACT_STRING)
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

   skip_octave (time: INTEGER_64; skip: INTEGER_8)
      do
         reference.set(reference.source, reference.note, reference.octave - skip.to_integer_32)
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
      end

   end_beam
      do
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         slur := once "("
      end

   end_slur
      do
         if slur = Void then
            append_last(once ")")
         else
            sedb_breakpoint
         end
      end

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         slur := once "\("
      end

   end_phrasing_slur
      do
         if slur = Void then
            append_last(once "\)")
         else
            sedb_breakpoint
         end
      end

   start_repeat (volte: INTEGER_64)
      do
      end

   end_repeat
      do
      end

feature {MIXUP_LILYPOND_STAFF}
   string_event (a_string: FIXED_STRING)
      require
         a_string /= Void
      do
         add_item(create {MIXUP_LILYPOND_STRING}.make(a_string))
      end

feature {ANY}
   generate_relative (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION)
      local
         ref: MIXUP_NOTE_HEAD; found: BOOLEAN; i, octave: INTEGER
      do
         section.set_body("\relative c")
         from
            i := items.lower
         until
            found or else i > items.upper
         loop
            found := items.item(i).valid_reference
            if found then
               ref := items.item(i).reference
            else
               i := i + 1
            end
         end
         if found then
            octave := ref.octave
            if octave < 3 then
               from
               until
                  octave < 0
               loop
                  section.set_body(once ",")
                  octave := octave - 1
               end
            elseif octave > 3 then
               from
               until
                  octave = 3
               loop
                  section.set_body(once "'")
                  octave := octave - 1
               end
            end
         end
      end

   generate (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION)
      do
         items.do_all(agent {MIXUP_LILYPOND_ITEM}.generate(context, section))
         section.set_body(once "%N")
      end

feature {}
   make (a_id: like id; a_reference: like reference; a_lyrics_gatherer: like lyrics_gatherer)
      do
         make_abstract(a_id, a_lyrics_gatherer)
         if not a_reference.is_rest then
            reference := a_reference
         end
      end

   dynamics: STRING
   slur: STRING

   dynamics_is_open: BOOLEAN
   dynamics_is_hidden: BOOLEAN
   dynamics_position: FIXED_STRING

   dyn_markup (a_dynamics: ABSTRACT_STRING; is_standard: BOOLEAN): ABSTRACT_STRING
      do
         if is_standard then
            Result := "\dynamic " + a_dynamics
         else
            Result := "\italic %"" + a_dynamics + "%""
         end
      end

   dyn_position (position: ABSTRACT_STRING)
      require
         dynamics /= Void
      do
         if position = Void then
            dynamics_is_hidden := False
            dynamics.extend('-')
         else
            inspect
               position.intern
            when "up" then
               dynamics_is_hidden := False
               dynamics.extend('^')
            when "down" then
               dynamics_is_hidden := False
               dynamics.extend('_')
            when "top" then
               not_yet_implemented
            when "bottom" then
               not_yet_implemented
            when "hidden" then
               dynamics_is_hidden := True
            end
         end
      end

   open_dynamics (position: ABSTRACT_STRING)
      require
         dynamics /= Void
      do
         dyn_position(position)
         if not dynamics_is_hidden then
            dynamics.append(once "\markup{")
         end
         dynamics_is_open := True
      ensure
         dynamics_is_open
      end

   close_dynamics
      require
         dynamics_is_open
      do
         if not dynamics_is_hidden then
            dynamics.extend('}')
         end
         dynamics_is_open := False
      ensure
         not dynamics_is_open
      end

invariant
   dynamics_is_open implies dynamics /= Void

end -- class MIXUP_LILYPOND_VOICE
