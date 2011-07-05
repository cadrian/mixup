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
deferred class MIXUP_IMPORT

inherit
   MIXUP_CONTEXT
      rename
         make as make_context
      end

feature {ANY}
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      do
         check
            never_called: False
         end
         crash
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE is
      do
         check Result = Void end
      end

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT) is
      do
         check
            never_called: False
         end
         crash
      end

feature {}
   valid_identifier (identifier: FIXED_STRING): BOOLEAN is
      require
         identifier /= Void
      deferred
      end

   child_identifier (identifier: FIXED_STRING): FIXED_STRING is
      deferred
      end

   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE is
      do
         if child.lookup_tag < lookup_tag and then valid_identifier(identifier) then
            Result := child.lookup_value(child_identifier(identifier), False, lookup_tag)
         end
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      do
         if child.lookup_tag < lookup_tag and then valid_identifier(identifier) then
            Result := child.setup_value(child_identifier(identifier), False, a_value, is_const, is_public, is_local, lookup_tag)
         end
      end

feature {}
   child: MIXUP_CONTEXT

invariant
   child /= Void
   not ({MIXUP_IMPORT} ?:= child)

end -- class MIXUP_IMPORT
