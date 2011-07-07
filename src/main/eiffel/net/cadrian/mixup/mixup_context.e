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
deferred class MIXUP_CONTEXT

inherit
   VISITABLE

insert
   MIXUP_ERRORS

feature {ANY}
   name: FIXED_STRING
   resolver: MIXUP_RESOLVER
   timing: MIXUP_MUSIC_TIMING

   commit (a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like Current is
      deferred
      ensure
         Result /= Void
         Result /= Current
         Result.timing.is_set
         Result.timing.first_bar_number = a_start_bar_number
      end

   hook (hook_name: ABSTRACT_STRING; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      local
         full_hook_name: STRING
      do
         full_hook_name := once ""
         full_hook_name.clear_count
         full_hook_name.append(once "hook.")
         full_hook_name.append(hook_name)
         Result := lookup(full_hook_name.intern, a_player, False)
      end

   lookup (identifier: FIXED_STRING; a_player: MIXUP_PLAYER; search_parent: BOOLEAN): MIXUP_VALUE is
      require
         identifier /= Void
         a_player /= Void
      do
         lookup_tag_counter.next
         Result := lookup_value(identifier, search_parent, lookup_tag_counter.item)
         debug
            log.trace.put_string("Look-up of '" + identifier + "' returned ")
            if Result = Void then
               log.trace.put_line("nothing")
            else
               log.trace.put_line(Result.out)
            end
         end
      end

   setup (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN) is
      require
         identifier /= Void
         a_value /= Void
         is_local implies not is_const
      local
         done: BOOLEAN
      do
         lookup_tag_counter.next
         done := setup_value(identifier, True, a_value, is_const, is_public, is_local, lookup_tag_counter.item)
         if not done then
            fatal("Could not assign value to " + identifier.out)
         end
      end

   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      require
         a_name /= Void
         a_value /= Void
      deferred
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE is
      deferred
      end

   run_hook (a_source: MIXUP_SOURCE; a_player: MIXUP_PLAYER; hook_name: STRING) is
      local
         h, res: MIXUP_VALUE
      do
         h := hook(hook_name, a_player)
         if h = Void then
            -- nothing to do
         elseif h.is_callable then
            res := h.call(a_source, a_player, create {FAST_ARRAY[MIXUP_VALUE]}.make(0), 0)
            if res /= Void then
               warning("lost result")
            end
         else
            fatal("hook not callable")
         end
      end

feature {MIXUP_CONTEXT}
   lookup_value (identifier: FIXED_STRING; search_parent: BOOLEAN; a_tag: like lookup_tag): MIXUP_VALUE is
      require
         a_tag > lookup_tag
         identifier /= Void
      local
         val: MIXUP_VALUE_IN_CONTEXT
      do
         lookup_tag := a_tag
         Result := get_local(identifier)
         if Result = Void then
            val := values.reference_at(identifier)
            if val /= Void then
               Result := val.value
               log.trace.put_line("Found identifier '" + identifier.out + "' in {" + generating_type + "}." + name + " => " + Result.out)
            end
         end
         if Result = Void then
            debug
               log.trace.put_line("{" + generating_type + "}." + name + ": look-up identifier '" + identifier.out + "' in children")
            end
            Result := lookup_in_children(identifier)
            if Result = Void then
               debug
                  log.trace.put_line("{" + generating_type + "}." + name + ": look-up identifier '" + identifier.out + "' in imports")
               end
               Result := lookup_in_imports(identifier)
               if Result = Void and then search_parent and then parent /= Void and then parent.lookup_tag < a_tag then
                  debug
                     log.trace.put_line("{" + generating_type + "}." + name + ": look-up identifier '" + identifier.out + "' in parent")
                  end
                  Result := parent.lookup_value(identifier, True, a_tag)
               end
            end
         end
      end

   setup_value (identifier: FIXED_STRING; assign_if_new: BOOLEAN; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN; a_tag: like lookup_tag): BOOLEAN is
      require
         a_tag > lookup_tag
         identifier /= Void
         a_value /= Void
         is_local implies not is_const
      local
         val: MIXUP_VALUE_IN_CONTEXT
         value: MIXUP_VALUE
      do
         lookup_tag := a_tag
         if is_local then
            value := get_local(identifier)
         end
         if value /= Void then
            check is_local end
            set_local(identifier, a_value)
            Result := True
         else
            val := values.reference_at(identifier)
            if val /= Void then
               if val.is_const then
                  fatal_at(a_value.source, "Cannot set const")
               elseif is_const then
                  warning_at(a_value.source, "Setting const in place of non-const")
               else
                  log.trace.put_line("Found identifier '" + identifier.out + "' in {" + generating_type + "}." + name)
               end
               set_value(identifier, a_value, is_const, is_public, is_local)
               Result := True
            else
               Result := setup_in_children(identifier, a_value, is_const, is_public, is_local)
               if not Result then
                  Result := setup_in_imports(identifier, a_value, is_const, is_public, is_local)
                  if not Result and then parent /= Void and then parent.lookup_tag < a_tag then
                     Result := parent.setup_value(identifier, False, a_value, is_const, is_public, is_local, a_tag)
                  end
                  if not Result and then assign_if_new then
                     log.trace.put_line("Assigning new identifier '" + identifier.out + "' to {" + generating_type + "}." + name)
                     set_value(identifier, a_value, is_const, is_public, is_local)
                     Result := True
                  end
               end
            end
         end

         debug
            if not Result then
               log.trace.put_line("Did not find identifier '" + identifier.out + "' in {" + generating_type + "}." + name)
            end
         end
      end

   add_child (a_child: MIXUP_CONTEXT) is
      require
         a_child /= Void
         a_child /= Current
         not ({MIXUP_IMPORT} ?:= a_child)
      deferred
      end

   add_import (a_import: MIXUP_IMPORT) is
      require
         a_import /= Void
      do
         imports.add_last(a_import)
      end

   set_timing (a_timing: like timing) is
      require
         a_timing.is_set
      do
         timing := a_timing --.set(a_timing.duration, a_timing.first_bar_number, a_timing.bars_count)
      ensure
         timing.is_set
         timing = a_timing
      end

feature {MIXUP_CONTEXT}
   lookup_tag: INTEGER

feature {}
   set_value (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN) is
      do
         if log.is_trace then
            log.trace.put_string("Setting ")
            if is_public then
               log.trace.put_string("public ")
            end
            if is_const then
               log.trace.put_string("const ")
            end
            if is_local then
               log.trace.put_string("local ")
            end
            log.trace.put_line("identifier '" + identifier.out + "' to {" + generating_type + "}." + name)
         end
         if is_local then
            set_local(identifier, a_value)
         else
            values.put(create {MIXUP_VALUE_IN_CONTEXT}.make(a_value, is_const, is_public), identifier)
         end
      end

feature {}
   values: DICTIONARY[MIXUP_VALUE_IN_CONTEXT, FIXED_STRING]
   parent: MIXUP_CONTEXT
   imports: FAST_ARRAY[MIXUP_IMPORT]

   commit_values (a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like values is
      local
         values_: HASHED_DICTIONARY[MIXUP_VALUE_IN_CONTEXT, FIXED_STRING]
      do
         create values_.with_capacity(values.count)
         values.do_all(agent values_.add)
         Result := values_
      end

   commit_imports (a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like imports is
      do
         create Result.with_capacity(imports.count)
         imports.do_all(agent (a_imports: like imports; player_: MIXUP_PLAYER; start_bar_number_: INTEGER; a_import: MIXUP_IMPORT) is
                        do
                           a_imports.add_last(a_import.commit(player_, start_bar_number_))
                        end(Result, a_player, a_start_bar_number, ?))
      end

   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE is
      require
         identifier /= Void
      deferred
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      require
         identifier /= Void
         a_value /= Void
      deferred
      end

   lookup_in_imports (identifier: FIXED_STRING): MIXUP_VALUE is
      require
         identifier /= Void
      local
         i: INTEGER
      do
         from
            i := imports.lower
         until
            Result /= Void or else i > imports.upper
         loop
            log.trace.put_line("TAG: " + name.out + "=" + lookup_tag.out
                               + " - " + imports.item(i).name.out + "=" + imports.item(i).lookup_tag.out)
            if imports.item(i).lookup_tag < lookup_tag then
               Result := imports.item(i).lookup_value(identifier, False, lookup_tag)
            end
            i := i + 1
         end
      end

   setup_in_imports (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      require
         identifier /= Void
         a_value /= Void
      local
         i: INTEGER
      do
         from
            i := imports.lower
         until
            Result or else i > imports.upper
         loop
            if imports.item(i).lookup_tag < lookup_tag then
               Result := imports.item(i).setup_value(identifier, False, a_value, is_const, is_public, is_local, lookup_tag)
            end
            i := i + 1
         end
      end

   lookup_tag_counter: COUNTER is
      once
         create Result
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         source := a_source
         name := a_name.intern
         parent := a_parent
         create {HASHED_DICTIONARY[MIXUP_VALUE_IN_CONTEXT, FIXED_STRING]} values.make
         create imports.make(0)

         create resolver.make(Current)
      ensure
         source = a_source
         name = a_name.intern
         parent = a_parent
      end

invariant
   source /= Void
   name /= Void
   values /= Void
   resolver /= Void
   imports /= Void

end -- class MIXUP_CONTEXT
