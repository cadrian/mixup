class AUX_MIXUP_MOCK_EVENT

insert
   ANY
      redefine
         is_equal, out_in_tagged_out_memory
      end

create {AUX_MIXUP_MOCK_PLAYER_EVENTS}
   make

feature {ANY}
   name: STRING
   values: TUPLE

   is_equal (other: like Current): BOOLEAN is
      do
         Result := name.is_equal(other.name) and then values.is_equal(other.values)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.extend('%N')
         tagged_out_memory.extend('{')
         tagged_out_memory.append(name)
         tagged_out_memory.extend(':')
         values.out_in_tagged_out_memory
         tagged_out_memory.extend('}')
      end

feature {}
   make (a_name: like name; a_values: like values) is
      require
         a_name /= Void
         a_values /= Void
      do
         name := a_name
         values := a_values
      ensure
         name = a_name
         values = a_values
      end

invariant
   name /= Void
   values /= Void

end
