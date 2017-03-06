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
deferred class MIXUP_TRANSFORM_CALL

insert
   MIXUP_TRANSFORM_TYPES

feature {MIXUP_TRANSFORM_CALLS}
   item (a_target: MIXUP_TRANSFORM_VALUE; a_arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
      deferred
      end

   call (a_target: MIXUP_TRANSFORM_VALUE; a_arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): ABSTRACT_STRING
      deferred
      end

   check_arguments (t: MIXUP_TRANSFORM_VALUE; a: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): ABSTRACT_STRING
      local
         i: INTEGER; err: ABSTRACT_STRING
      do
         if t = Void then
            if target /= Void then
               Result := "target is Void, expected target type is #(1)" # target.name
            end
         elseif t.type /= target then
            Result := "target is #(1), expected target type is #(2)" # t.type.name # target.name
         end
         if Result = Void then
            if a.count /= arguments.count then
               Result := "bad number of arguments: got #(1) but expected #(2)" # &a.count # &arguments.count
            else
               from
                  i := a.lower
               until
                  i > a.upper
               loop
                  if a.item(i) = Void then
                     err := "argument ##(1) is Void" # &(i - a.lower + 1)
                  elseif arguments.item(arguments.lower + i - a.lower) = type_unknown then
                     -- OK
                  elseif a.item(i).type /= arguments.item(arguments.lower + i - a.lower) then
                     err := "invalid argument ##(1) type: got #(2) but expected #(3)" # &(i - a.lower + 1)
                            # a.item(i).type.name # arguments.item(arguments.lower + i - a.lower).name
                  else
                     err := Void
                  end
                  if err /= Void then
                     if Result = Void then
                        Result := err
                     else
                        Result := "#(1), #(2)" # Result # err
                     end
                  end
                  i := i + 1
               end
            end
         end
      end

feature {}
   name: STRING
   target: MIXUP_TRANSFORM_TYPE
   arguments: TRAVERSABLE[MIXUP_TRANSFORM_TYPE]

invariant
   name /= Void
   arguments /= Void

end -- class MIXUP_TRANSFORM_CALL
