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

feature {ANY}
   id: INTEGER

   duration: INTEGER_64 is
      do
         Result := voices.duration
      end

   valid_anchor: BOOLEAN is
      do
         Result := voices.valid_anchor
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := voices.anchor
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      do
         Result := voices.commit(a_context, a_player, start_bar_number)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         a_context.set_staff_id(id)
         Result := voices.new_events_iterator(a_context)
      end

   bars: ITERABLE[INTEGER_64] is
      do
         Result := voices.bars
      end

   voice_ids: TRAVERSABLE[INTEGER] is
      do
         Result := voices.voice_ids
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "[staff#")
         id.append_in(tagged_out_memory)
         tagged_out_memory.extend(':')
         voices.out_in_tagged_out_memory
         tagged_out_memory.extend(']')
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (a_bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
         voices.consolidate_bars(a_bars, duration_offset)
      end

   add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
         check False end
      end

feature {}
   make (a_source: like source; a_voices: like voices) is
      require
         a_source /= Void
         a_voices /= Void
      do
         source := a_source
         voices := a_voices
         id_provider.next
         id := id_provider.item
         debug
            log.trace.put_line("Staff #" + id.out + ": voices=" + a_voices.out)
         end
      ensure
         source = a_source
         voices = a_voices
      end

   voices: MIXUP_VOICES

   id_provider: COUNTER is
      once
         create Result
      end

invariant
   voices /= Void
   id > 0

end -- class MIXUP_STAFF
