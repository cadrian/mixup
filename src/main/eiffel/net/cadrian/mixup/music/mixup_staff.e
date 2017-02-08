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
class MIXUP_STAFF

inherit
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

create {MIXUP_STAFF}
   duplicate

feature {ANY}
   timing: MIXUP_MUSIC_TIMING
      do
         Result := voices.timing
      end

   id: INTEGER

   valid_anchor: BOOLEAN
      do
         Result := voices.valid_anchor
      end

   anchor: MIXUP_NOTE_HEAD
      do
         Result := voices.anchor
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      local
         voices_: like voices
      do
         a_commit_context.set_staff(Current)
         voices_ := voices.commit(a_commit_context)
         create Result.duplicate(source, id, voices_)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR
      do
         a_context.set_staff_id(id)
         Result := voices.new_events_iterator(a_context)
      end

   voice_ids: TRAVERSABLE[INTEGER]
      do
         Result := voices.voice_ids
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "[staff#")
         id.append_in(tagged_out_memory)
         tagged_out_memory.extend(':')
         voices.out_in_tagged_out_memory
         tagged_out_memory.extend(']')
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   add_voice_ids (ids: AVL_SET[INTEGER])
      do
         check False end
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER)
      do
         voices.set_timing(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_voices: like voices)
      require
         a_source /= Void
         a_voices /= Void
      do
         source := a_source
         voices := a_voices
         id_provider.next
         id := id_provider.item
         debug
            log.trace.put_line(once "Staff #" | &id | once ": voices=" | &a_voices)
         end
      ensure
         source = a_source
         voices = a_voices
      end

   duplicate (a_source: like source; a_id: like id; a_voices: like voices)
      do
         source := a_source
         id := a_id
         voices := a_voices
      end

   voices: MIXUP_VOICES

   id_provider: COUNTER
      once
         create Result
      end

invariant
   voices /= Void
   id > 0

end -- class MIXUP_STAFF
