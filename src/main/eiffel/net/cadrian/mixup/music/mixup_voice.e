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
class MIXUP_VOICE

inherit
   MIXUP_SPANNER

create {ANY}
   make

create {MIXUP_VOICE}
   duplicate

feature {ANY}
   valid_anchor: BOOLEAN is True

   duration: INTEGER_64 is
      do
         Result := timing.duration
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         a_context.set_voice_id(id)
         create {MIXUP_EVENTS_ITERATOR_ON_VOICE} Result.make(a_context, music)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.extend('<')
         tagged_out_memory.extend('#')
         id.append_in(tagged_out_memory)
         music.do_all(agent (mus: MIXUP_MUSIC) is
                         do
                            tagged_out_memory.extend(' ')
                            mus.out_in_tagged_out_memory
                         end)
         tagged_out_memory.extend('>')
      end

feature {}
   duplicate (a_source: like source; a_reference: like reference; a_id: like id; a_music: like music) is
      do
         source := a_source
         reference := a_reference
         id := a_id
         music := a_music
      end

   do_duplicate (a_music: like music; a_timing: like timing): like Current is
      do
         create Result.duplicate(source, reference, id, a_music)
         Result.set_timing(a_timing.duration, a_timing.first_bar_number, a_timing.bars_count)
      end

end -- class MIXUP_VOICE
