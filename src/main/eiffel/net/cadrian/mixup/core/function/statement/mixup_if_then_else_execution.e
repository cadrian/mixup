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
class MIXUP_IF_THEN_ELSE_EXECUTION

inherit
   MIXUP_EXECUTION_CONTEXT

create {ANY}
   make

feature {ANY}
   match (a_if: MIXUP_IF): BOOLEAN is
      local
         value: MIXUP_VALUE
      do
         match_ := False
         value := a_if.condition.eval(context, context.player)
         if value = Void then
            not_yet_implemented -- error: value could not be computed
         else
            value.accept(Current)
            if match_ then
               Result := True
               context.add_statements(a_if.statements)
            end
         end
      end

feature {}
   match_: BOOLEAN

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
         match_ := a_boolean.value
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
         not_yet_implemented -- error: cannot match on an integer
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
         not_yet_implemented -- error: cannot match on a real
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
         not_yet_implemented -- error: cannot match on a string
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         not_yet_implemented -- error: cannot match on music
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         not_yet_implemented -- error: cannot match on iterator
      end

feature {}
   make (a_context: like context) is
      require
         a_context /= Void
      do
         context := a_context
      ensure
         context = a_context
      end

end -- class MIXUP_IF_THEN_ELSE_EXECUTION
