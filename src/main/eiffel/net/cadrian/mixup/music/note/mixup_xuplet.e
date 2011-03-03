class MIXUP_XUPLET

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

   capacity: INTEGER
   xuplet: INTEGER
   duration: INTEGER_64

   is_equal (other: like Current): BOOLEAN is
      local
         i: INTEGER
      do
         Result := capacity = other.capacity
            and then xuplet = other.xuplet
            and then duration = other.duration
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
   manifest_make (a_capacity, a_xuplet: INTEGER; a_duration: INTEGER_64) is
      require
         a_capacity > 0
         a_xuplet > 0
         a_duration > 0
      do
         capacity := a_capacity
         xuplet := a_xuplet
         duration := a_duration
         storage := storage.calloc(a_capacity)
      end

   manifest_put (index: INTEGER; element: MIXUP_NOTE) is
      do
         storage.put(element, index)
      end

   manifest_semicolon_check: BOOLEAN is False

feature {MIXUP_XUPLET}
   storage: NATIVE_ARRAY[MIXUP_NOTE]

end
