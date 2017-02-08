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
class MIXUP_MUSIC_STORE

inherit
   MIXUP_VALUE
      undefine
         out_in_tagged_out_memory
      end
   MIXUP_VOICES
      rename
         make as make_voices
      end

create {ANY}
   make

create {MIXUP_MUSIC_STORE}
   duplicate

feature {ANY}
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_music_store(Current)
      end

   has_voice: BOOLEAN
      do
         Result := not voices.is_empty
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING)
      do
         a_name.append(once "<music store>")
      end

feature {}
   make (a_source: like source)
      require
         a_source /= Void
      do
         make_voices(a_source, ref0)
      ensure
         source = a_source
      end

   ref0: MIXUP_NOTE_HEAD
      once
         Result.set(create {MIXUP_SOURCE_UNKNOWN}, "a", 3)
      end

   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      do
         Result := Current
      end

end -- class MIXUP_MUSIC_STORE
