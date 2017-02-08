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
class MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS
   --
   -- Iterator on parallel instruments
   --

inherit
   MIXUP_EVENTS_PARALLEL_ITERATOR
   MIXUP_CONTEXT_VISITOR
      undefine
         is_equal
      redefine
         visit_instrument
      end

insert
   MIXUP_ERRORS
      undefine
         is_equal
      end

create {MIXUP_MIXER_CONDUCTOR}
   make

feature {MIXUP_INSTRUMENT}
   visit_instrument (a_instrument: MIXUP_INSTRUMENT)
      do
         instruments.add_last(a_instrument)
      end

feature {}
   make (a_context: MIXUP_CONTEXT)
      require
         a_context /= Void
      do
         create {FAST_ARRAY[MIXUP_INSTRUMENT]} instruments.make(0)
         a_context.accept(Current)
         if instruments.is_empty then
            fatal_at(a_context.source, "No instrument found")
         end
         start
      end

   add_notes_iterator
      do
         instruments.do_all(agent add_note_iterator)
      end

   add_note_iterator (a_instrument: MIXUP_INSTRUMENT)
      do
         notes.add_last(a_instrument.new_events_iterator)
      end

   count: INTEGER
      do
         Result := instruments.count
      end

   instruments: COLLECTION[MIXUP_INSTRUMENT]

invariant
   instruments /= Void

end -- class MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS
