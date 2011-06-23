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
class MIXUP_MIDI_MPC_END_FACTORY

inherit
   MIXUP_VALUE
      redefine
         out_in_tagged_out_memory
      end
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {MIXUP_MIDI_PLAYER}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR) is
      do
         (create {MIXUP_MUSIC_VALUE}.make(source, Current)).accept(visitor)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "{MIXUP_MIDI_MPC_END_FACTORY ")
         value.out_in_tagged_out_memory
         tagged_out_memory.append(once "}")
      end

   value: INTEGER_8
   mpc_start: MIXUP_MIDI_MPC_START_FACTORY

feature {ANY}
   duration: INTEGER_64 is 0

   valid_anchor: BOOLEAN is False

   anchor: MIXUP_NOTE_HEAD is
      do
         crash
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      do
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_MIDI_MPC_END}.make(a_context.event_data(source), mpc_start.last_mpc_start, mpc_start.knob, mpc_start.value, value))
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

   add_voice_ids (a_ids: AVL_SET[INTEGER]) is
      do
      end

feature {}
   make (a_source: like source; a_mpc_start: like mpc_start; a_value: like value) is
      require
         a_source /= Void
         a_mpc_start /= Void
         a_mpc_start.mpc_end = Void
      do
         source := a_source
         mpc_start := a_mpc_start
         mpc_start.set_mpc_end(Current)
         value := a_value
      ensure
         source = a_source
         mpc_start = a_mpc_start
         value = a_value
         a_mpc_start.mpc_end = Current
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(once "<mpc end>")
      end

invariant
   mpc_start /= Void

end -- class MIXUP_MIDI_MPC_END_FACTORY
