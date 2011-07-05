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
expanded class MIXUP_EVENTS_ITERATOR_CONTEXT
--
-- Any information that must be sent down events when iterating. No
-- information can be sent back to parent events (kinda same principle
-- as Unix environment rules)
--
-- For example, it is not the place where to store the bar number.
--

insert
   ANY
      redefine
         default_create
      end

create {ANY}
   default_create

feature {ANY}
   instrument: MIXUP_INSTRUMENT
   staff_id: INTEGER
   voice_id: INTEGER
   start_time: INTEGER_64
   xuplet_numerator: INTEGER_64
   xuplet_denominator: INTEGER_64
   xuplet_text: FIXED_STRING

   set_instrument (a_instrument: like instrument) is
      do
         instrument := a_instrument
      ensure
         instrument = a_instrument
      end

   set_staff_id (a_staff_id: like staff_id) is
      do
         staff_id := a_staff_id
      ensure
         staff_id = a_staff_id
      end

   set_voice_id (a_voice_id: like voice_id) is
      do
         voice_id := a_voice_id
      ensure
         voice_id = a_voice_id
      end

   event_data (a_source: MIXUP_SOURCE): MIXUP_EVENT_DATA is
      require
         a_source /= Void
      do
         Result.set(a_source, start_time, instrument, staff_id, voice_id)
      end

   add_time (duration: INTEGER_64) is
      do
         start_time := start_time + duration * xuplet_denominator // xuplet_numerator -- yes, musical fractions are written in reverse (3/2 => three parts in two => multiply times by 2/3)
      end

   set_xuplet (num, den: INTEGER_64; txt: FIXED_STRING) is
      do
         xuplet_numerator   := num * xuplet_numerator
         xuplet_denominator := den * xuplet_denominator
         xuplet_text        := txt
      end

feature {}
   default_create is
      do
         instrument := Void
         start_time := 0
         xuplet_numerator := 1
         xuplet_denominator := 1
         xuplet_text := no_text
      end

   no_text: FIXED_STRING is
      once
         Result := "".intern
      end

end -- class MIXUP_EVENTS_ITERATOR_CONTEXT
