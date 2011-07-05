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
expanded class MIXUP_MUSIC_TIMING

insert
   COMPARABLE
      redefine
         immutable, out_in_tagged_out_memory
      end

feature {ANY}
   duration: INTEGER_64
   first_bar_number: INTEGER
   bars_count: INTEGER
   is_set: BOOLEAN

   set (a_duration: like duration; a_first_bar_number: like first_bar_number; a_bars_count: like bars_count): like Current is
      require
         dont_set_twice: not is_set
      do
         duration := a_duration
         first_bar_number := a_first_bar_number
         bars_count := a_bars_count
         is_set := True
         Result := Current
      ensure
         duration = a_duration
         first_bar_number = a_first_bar_number
         bars_count = a_bars_count
         is_set
      end

   infix "+" (other: like Current): like Current is
      require
         is_set
         other.is_set
         other.first_bar_number = first_bar_number + bars_count
      do
         Result := Result.set(duration + other.duration, first_bar_number, bars_count + other.bars_count)
      end

   immutable: BOOLEAN is
      do
         Result := is_set
      end

   infix "<" (other: like Current): BOOLEAN is
      do
         if is_set /= other.is_set then
            Result := other.is_set
         elseif is_set then
            if duration /= other.duration then
               Result := duration < other.duration
            elseif first_bar_number /= other.first_bar_number then
               Result := first_bar_number < other.first_bar_number
            elseif bars_count /= other.bars_count then
               Result := bars_count < other.bars_count
            end
         end
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "[duration=")
         duration.out_in_tagged_out_memory
         tagged_out_memory.append(once ", first bar=")
         first_bar_number.out_in_tagged_out_memory
         tagged_out_memory.append(once ", bars count=")
         bars_count.out_in_tagged_out_memory
         tagged_out_memory.extend(']')
      end

end -- class MIXUP_MUSIC_TIMING
