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
expanded class MIXUP_TRANSFORM_CALLS

feature {ANY}
   register_function (name: STRING; target: MIXUP_TRANSFORM_TYPE; arguments: TRAVERSABLE[MIXUP_TRANSFORM_TYPE]; return: MIXUP_TRANSFORM_TYPE;
                      function: FUNCTION[TUPLE[MIXUP_TRANSFORM_CALL_CONTEXT], TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]])
      require
         name /= Void
         arguments /= Void
         return /= Void
         function /= Void
      local
         f: like calls_no_target
      do
         if target = Void then
            f := calls_no_target
         else
            f := calls.fast_reference_at(target)
            if f = Void then
               create f
               calls.add(f, target)
            end
         end
         f.add(create {MIXUP_TRANSFORM_FUNCTION}.make(name, target, arguments, return, function), name)
      end

   register_procedure (name: STRING; target: MIXUP_TRANSFORM_TYPE; arguments: TRAVERSABLE[MIXUP_TRANSFORM_TYPE];
                       procedure: FUNCTION[TUPLE[MIXUP_TRANSFORM_CALL_CONTEXT], ABSTRACT_STRING])
      require
         name /= Void
         arguments /= Void
         procedure /= Void
      local
         p: like calls_no_target
      do
         if target = Void then
            p := calls_no_target
         else
            p := calls.fast_reference_at(target)
            if p = Void then
               create p
               calls.add(p, target)
            end
         end
         p.add(create {MIXUP_TRANSFORM_PROCEDURE}.make(name, target, arguments, procedure), name)
      end

   register_def (name: STRING; def: MIXUP_TRANSFORM_DEF): ABSTRACT_STRING
      require
         name /= Void
         def /= Void
      do
         if calls_no_target.has(name) then
            Result := "Function or procedure already exists: #(1)" # name
         else
            calls_no_target.add(def, name)
         end
      end

feature {MIXUP_TRANSFORM_CALL_RUNNER}
   call_function (name: STRING; target: MIXUP_TRANSFORM_VALUE; arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
      require
         name /= Void
         arguments /= Void
      local
         f: like calls_no_target
         c: MIXUP_TRANSFORM_CALL
         err: ABSTRACT_STRING
         v: MIXUP_TRANSFORM_VALUE
      do
         if target = Void then
            f := calls_no_target
         else
            f := calls.fast_reference_at(target.type)
            if f = Void then
               err := "unknown function for target type: #(1)" # target.type.name
            end
         end
         if err = Void then
            check f /= Void end
            c := f.reference_at(name)
            if c = Void then
               err := "unknown function: #(1)" # name
            else
               err := c.check_arguments(target, arguments)
               if err = Void then
                  Result := c.item(target, arguments)
               end
            end
         end
         if Result = Void then
            check
               v = Void -- used only to fix the tuple type
               err /= Void
            end
            Result := [v, err]
         end
      ensure
         Result /= Void
         Result.second = Void implies Result.first /= Void
      end

   call_procedure (name: STRING; target: MIXUP_TRANSFORM_VALUE; arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): ABSTRACT_STRING
      require
         name /= Void
         arguments /= Void
      local
         p: like calls_no_target
         c: MIXUP_TRANSFORM_CALL
      do
         if target = Void then
            p := calls_no_target
         else
            p := calls.fast_reference_at(target.type)
            if p = Void then
               Result := "unknown procedure for target type: #(1)" # target.type.name
            end
         end
         if Result = Void then
            check p /= Void end
            c := p.reference_at(name)
            if c = Void then
               Result := "unknown procedure: #(1)" # name
            else
               Result := c.check_arguments(target, arguments)
               if Result = Void then
                  Result := c.call(target, arguments)
               end
            end
         end
      end

feature {}
   calls_no_target: HASHED_DICTIONARY[MIXUP_TRANSFORM_CALL, STRING]
      once
         create Result
      end

   calls: HASHED_DICTIONARY[HASHED_DICTIONARY[MIXUP_TRANSFORM_CALL, STRING], MIXUP_TRANSFORM_TYPE]
      once
         create Result
      end

end -- class MIXUP_TRANSFORM_CALLS
