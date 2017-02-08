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
class MIXUP_MIDI_NOTE

inherit
   MIXUP_MIDI_ITEM
   MIXUP_NOTE_VISITOR

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   duration: INTEGER_64

   generate (context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION)
      do
         precision := section.precision
         note.accept(Current)
      end

   fix_slur (a_slur_numerator: like slur_numerator; a_slur_denominator: like slur_denominator)
      require
         a_slur_numerator > 0
         a_slur_denominator > 0
      do
         slur_numerator := a_slur_numerator
         slur_denominator := a_slur_denominator
      ensure
         slur_numerator = a_slur_numerator
         slur_denominator = a_slur_denominator
      end

feature {MIXUP_CHORD}
   visit_chord (a_chord: MIXUP_CHORD)
      do
         duration := a_chord.duration
         a_chord.do_all(agent (head: MIXUP_NOTE_HEAD; tie: BOOLEAN; channel: INTEGER_8)
                        do
                           if not head.is_rest then
                              track.turn_on(channel, precision * time, pitch(head), precision * duration * slur_numerator // slur_denominator, dynamics.velocity(time))
                              if not tie then
                                 track.turn_off(channel, precision * time, pitch(head), dynamics.velocity(time))
                              end
                           end
                        end(?, a_chord.tie, track_id.to_integer_8))
      end

feature {MIXUP_LYRICS}
   visit_lyrics (a_lyrics: MIXUP_LYRICS)
      do
         a_lyrics.note.accept(Current)
         a_lyrics.do_all(agent (syl: MIXUP_SYLLABLE)
                         local
                            events: MIXUP_MIDI_META_EVENTS
                         do
                            log.info.put_line("SYLLABLE: %"" + syl.syllable + "%" at time " + time.out)
                            if syl.in_word then
                               track.add_event(precision * time, events.lyrics_event(syl.syllable))
                            else
                               track.add_event(precision * time, events.lyrics_event(" " + syl.syllable))
                            end
                         end)
      end

feature {}
   make (a_time: like time; a_note: like note; a_track: like track; a_track_id: like track_id;
         a_slur_numerator: like slur_numerator; a_slur_denominator: like slur_denominator;
         a_dynamics: like dynamics)
      require
         a_note /= Void
         a_track /= Void
         a_track_id.in_range(0, 15)
         a_slur_numerator > 0
         a_slur_denominator > 0
         a_dynamics /= Void
      do
         time := a_time
         note := a_note
         track := a_track
         track_id := a_track_id
         fix_slur(a_slur_numerator, a_slur_denominator)
         dynamics := a_dynamics
         a_dynamics.add_note(Current)
      ensure
         time = a_time
         note = a_note
         track = a_track
         track_id = a_track_id
         slur_numerator = a_slur_numerator
         slur_denominator = a_slur_denominator
         dynamics = a_dynamics
      end

   note: MIXUP_NOTE

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

   precision: INTEGER

   slur_numerator, slur_denominator: INTEGER

   dynamics: MIXUP_MIDI_DYNAMICS

   pitch (head: MIXUP_NOTE_HEAD): INTEGER_8
      require
         not head.is_rest
      do
         inspect
            head.note.out
         when "bis", "c" then
            Result := 0
         when "des", "cis" then
            Result := 1
         when "d" then
            Result := 2
         when "ees", "dis" then
            Result := 3
         when "e", "fes" then
            Result := 4
         when "f", "eis" then
            Result := 5
         when "ges", "fis" then
            Result := 6
         when "g" then
            Result := 7
         when "gis" then
            Result := 8
         when "aes" then
            Result := -4
         when "a" then
            Result := -3
         when "bes", "ais" then
            Result := -2
         when "b", "ces" then
            Result := -1
         end
         Result := Result + 12 * head.octave.to_integer_8
         if Result < 0 then
            Result := Result + 12
         elseif Result > 127 then
            Result := Result - 12
         end
      end

invariant
   note /= Void
   track /= Void
   track_id.in_range(0, 15)
   slur_numerator > 0
   slur_denominator > 0

end -- class MIXUP_MIDI_NOTE
