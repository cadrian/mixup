class MIXUP_LYRICS

inherit
   MIXUP_NOTE
      redefine
         is_equal, out_in_tagged_out_memory
      end

create {ANY}
   make, manifest_creation

feature {ANY}
   count: INTEGER is
      do
         Result := capacity
      end

   duration: INTEGER_64 is
      do
         Result := note.duration
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := note.anchor
      end

   capacity: INTEGER
   note: MIXUP_NOTE

   is_equal (other: like Current): BOOLEAN is
      local
         i: INTEGER
      do
         Result := capacity = other.capacity
            and then note.is_equal(other.note)
         from
            i := 0
         until
            not Result or else i = capacity
         loop
            Result := storage.item(i).is_equal(other.storage.item(i))
            i := i + 1
         end
      end

   out_in_tagged_out_memory is
      local
         i: INTEGER
      do
         tagged_out_memory.append(once "{MIXUP_LYRICS ")
         note.out_in_tagged_out_memory
         tagged_out_memory.append(once " << ")
         from
            i := 0
         until
            i = capacity
         loop
            if i > 0 then
               tagged_out_memory.append(once ", ")
            end
            tagged_out_memory.extend('"')
            tagged_out_memory.append(storage.item(i))
            tagged_out_memory.extend('"')
            i := i + 1
         end
         tagged_out_memory.append(once " >> }")
      end

   put (a_index: INTEGER; a_syllable: ABSTRACT_STRING) is
      require
         a_index.in_range(0, capacity - 1)
         a_syllable /= Void
      do
         manifest_put(a_index, a_syllable)
      end

feature {}
   make (a_capacity: INTEGER; a_note: MIXUP_NOTE) is
      do
         manifest_make(a_capacity, a_note)
      end

feature {} -- Manifest creation:
   manifest_make (a_capacity: INTEGER; a_note: MIXUP_NOTE) is
      require
         a_capacity > 0
         a_note /= Void
      do
         capacity := a_capacity
         note := a_note
         storage := storage.calloc(a_capacity)
      end

   manifest_put (index: INTEGER; syllable: ABSTRACT_STRING) is
      do
         storage.put(syllable.intern, index)
      end

   manifest_semicolon_check: BOOLEAN is False

feature {MIXUP_LYRICS}
   storage: NATIVE_ARRAY[FIXED_STRING]

invariant
   note /= Void

end
