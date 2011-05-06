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
deferred class MIXUP_CORE_PLAYER

inherit
   MIXUP_EVENT_SET_SCORE_PLAYER
   MIXUP_EVENT_END_SCORE_PLAYER
   MIXUP_EVENT_SET_BOOK_PLAYER
   MIXUP_EVENT_END_BOOK_PLAYER
   MIXUP_EVENT_SET_PARTITUR_PLAYER
   MIXUP_EVENT_END_PARTITUR_PLAYER
   MIXUP_EVENT_SET_INSTRUMENT_PLAYER
   MIXUP_EVENT_SET_DYNAMICS_PLAYER
   MIXUP_EVENT_SET_NOTE_PLAYER
   MIXUP_EVENT_NEXT_BAR_PLAYER
   MIXUP_EVENT_START_BEAM_PLAYER
   MIXUP_EVENT_END_BEAM_PLAYER
   MIXUP_EVENT_START_SLUR_PLAYER
   MIXUP_EVENT_END_SLUR_PLAYER
   MIXUP_EVENT_START_PHRASING_SLUR_PLAYER
   MIXUP_EVENT_END_PHRASING_SLUR_PLAYER
   MIXUP_EVENT_START_REPEAT_PLAYER
   MIXUP_EVENT_END_REPEAT_PLAYER

end -- class MIXUP_CORE_PLAYER
