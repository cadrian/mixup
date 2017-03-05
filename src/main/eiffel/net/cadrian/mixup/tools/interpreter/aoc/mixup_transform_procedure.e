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
class MIXUP_TRANSFORM_PROCEDURE

inherit
   MIXUP_TRANSFORM_CALL

create {MIXUP_TRANSFORM_CALLS}
   make

feature {MIXUP_TRANSFORM_CALLS}
   call (a_target: MIXUP_TRANSFORM_VALUE; a_arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): ABSTRACT_STRING
      local
         a: FAST_ARRAY[MIXUP_TRANSFORM_VALUE]
      do
         if a_target = Void then
            create a.with_capacity(a_arguments.count)
         else
            create a.with_capacity(a_arguments.count + 1)
            a.add_last(a_target)
         end
         a.append_traversable(a_arguments)
         Result := procedure.item([create {MIXUP_TRANSFORM_CALL_CONTEXT}.make(a_target, a_arguments)])
      end

feature {}
   make (a_name: like name; a_target: like target; a_arguments: like arguments; a_procedure: like procedure)
      require
         a_name /= Void
         a_arguments /= Void
         a_procedure /= Void
      do
         name := a_name
         target := a_target
         arguments := a_arguments
         procedure := a_procedure
      ensure
         name = a_name
         target = a_target
         arguments = a_arguments
         procedure = a_procedure
      end

   procedure: FUNCTION[TUPLE[MIXUP_TRANSFORM_CALL_CONTEXT], ABSTRACT_STRING]

end -- class MIXUP_TRANSFORM_PROCEDURE
