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
class MIXUP_MIDI_FILE_SEQUENCER

create {ANY}
   make

feature {ANY}
   is_off: BOOLEAN

   next
      require
         not is_off
      local
         i, index: INTEGER; found: BOOLEAN; t: like time; iter: MIXUP_MIDI_TRACK_ITERATOR
      do
         -- try to find the next event at the same time
         from
            t := time
            i := iterators.lower
         until
            found or else i > iterators.upper
         loop
            iter := iterators.item(i)
            if not iter.is_off then
               if iter.time = t then
                  iter.next
                  if not iter.is_off and then iter.time = t then
                     found := True
                     index := i
                  end
               end
            end
            i := i + 1
         end
         if not found then
            -- try to find the next event at the smallest next time
            from
               i := iterators.lower
               t := input.max_time
            until
               i > iterators.upper
            loop
               iter := iterators.item(i)
               if not iter.is_off and then iter.time <= t then
                  t := iter.time
                  index := i
                  found := True
               end
               i := i + 1
            end
         end
         set_attributes(found, index, t)
      end

   track_index: INTEGER
      require
         not is_off
      attribute
      end

   time: INTEGER_64
      require
         not is_off
      attribute
      end

   event: MIXUP_MIDI_CODEC
      require
         not is_off
      attribute
      end

   start
      local
         i, index: INTEGER; found: BOOLEAN; t: like time; iter: MIXUP_MIDI_TRACK_ITERATOR
      do
         is_off := False
         from
            i := iterators.lower
            t := input.max_time
         until
            i > iterators.upper
         loop
            iter := iterators.item(i)
            iter.start
            if not iter.is_off and then iter.time <= t then
               t := iter.time
               index := i
               found := True
            end
            i := i + 1
         end
         set_attributes(found, index, t)
      end

feature {}
   make (a_input: like input)
      require
         a_input /= Void
      local
         i: INTEGER; iter: MIXUP_MIDI_TRACK_ITERATOR
      do
         input := a_input
         from
            create iterators.with_capacity(a_input.track_count)
            i := 1
         until
            i > a_input.track_count
         loop
            iter := a_input.track(i).new_iterator
            iterators.add_last(iter)
            i := i + 1
         end
         start
      ensure
         input = a_input
      end

   input: MIXUP_MIDI_FILE
   iterators: FAST_ARRAY[MIXUP_MIDI_TRACK_ITERATOR]

   set_attributes (found: BOOLEAN; index: INTEGER; t: like time)
      require
         found implies iterators.valid_index(index)
      do
         if found then
            track_index := index + 1 -- beware, not same lower bound
            check
               t = iterators.item(index).time
            end
            time := t
            event := iterators.item(index).event
         else
            is_off := True
         end
      end

invariant
   input /= Void
   iterators /= Void
   iterators.count = input.track_count

end -- class MIXUP_MIDI_FILE_SEQUENCER
