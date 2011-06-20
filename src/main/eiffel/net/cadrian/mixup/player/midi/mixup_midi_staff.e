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
class MIXUP_MIDI_STAFF

inherit
   MIXUP_ABSTRACT_STAFF[MIXUP_MIDI_OUTPUT_STREAM,
                        MIXUP_MIDI_SECTION,
                        MIXUP_MIDI_ITEM,
                        MIXUP_MIDI_VOICE,
                        MIXUP_MIDI_VOICES
                        ]
      rename
         make as make_abstract
      redefine
         set_dynamics, generate
      end

create {ANY}
   make

feature {MIXUP_ABSTRACT_INSTRUMENT}
   generate (context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION; generate_names: BOOLEAN) is
      do
         Precursor(context, section, generate_names)
         all_dynamics.do_all(agent {MIXUP_MIDI_DYNAMICS}.generate(context, section, track, track_id))
      end

   set_dynamics (a_voice_id: INTEGER; dynamics, position: ABSTRACT_STRING) is
      local
         v: like voice; dyn: like last_dynamics
      do
         v := voice(a_voice_id)
         v.set_dynamics(dynamics, position)
         dyn := v.dynamics
         if dyn /= last_dynamics then
            all_dynamics.add_last(dyn)
         end
      end

feature {MIXUP_MIDI_INSTRUMENT}
   send_events (a_time: INTEGER_64; a_voice_id: INTEGER; a_events: HOARD[FUNCTION[TUPLE[INTEGER_8], MIXUP_MIDI_EVENT]]) is
      require
         a_events /= Void
      do
         voice(a_voice_id).send_events(a_time, a_events)
      end

feature {}
   generate_lyrics (lyr: AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]; index: INTEGER; context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION) is
      do
      end

   new_voices (a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]): like root_voices is
      do
         create Result.make(voice_ids, lyrics_gatherer, track, track_id, last_dynamics)
      end

   make (a_id: like id; a_voice_ids: TRAVERSABLE[INTEGER]; a_track: like track; a_track_id: like track_id) is
      require
         a_track /= Void
         a_track_id.in_range(0, 15)
      do
         track := a_track
         track_id := a_track_id
         create all_dynamics.with_capacity(4)
         all_dynamics.add_last(create {MIXUP_MIDI_DYNAMICS_NUANCE})
         make_abstract(a_id, a_voice_ids)
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

   last_dynamics: MIXUP_MIDI_DYNAMICS is
      do
         Result := all_dynamics.last
      end

   all_dynamics: FAST_ARRAY[MIXUP_MIDI_DYNAMICS]

invariant
   track /= Void
   track_id.in_range(0, 15)
   not all_dynamics.is_empty

end -- class MIXUP_MIDI_STAFF
