class MIXUP_LYRICS

inherit
   MIXUP_NOTE
      redefine
         is_equal
      end

create {ANY}
   manifest_creation

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

   manifest_put (index: INTEGER; syllable: STRING) is
      do
         storage.put(syllable, index)
      end

   manifest_semicolon_check: BOOLEAN is False

feature {MIXUP_LYRICS}
   storage: NATIVE_ARRAY[STRING]

invariant
   note /= Void

end
