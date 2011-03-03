class MIXUP_GROUPED_MUSIC

inherit
   MIXUP_COMPOUND_MUSIC

insert
   MIXUP_VOICE
      export
         {MIXUP_VOICE} consolidate_bars
      end

create {ANY}
   as_beam, as_slur, as_tie

feature {ANY}
   is_beam: BOOLEAN is
      do
         Result := kind = kind_beam
      end

   is_slur: BOOLEAN is
      do
         Result := kind = kind_slur
      end

   is_tie: BOOLEAN is
      do
         Result := kind = kind_tie
      end

feature {}
   as_beam (a_reference: like reference) is
      do
         make(a_reference)
         kind := kind_beam
      ensure
         kind = kind_beam
      end

   as_slur (a_reference: like reference) is
      do
         make(a_reference)
         kind := kind_slur
      ensure
         kind = kind_slur
      end

   as_tie (a_reference: like reference) is
      do
         make(a_reference)
         kind := kind_tie
      ensure
         kind = kind_tie
      end

   kind: INTEGER_8

   kind_beam: INTEGER_8 is 1
   kind_slur: INTEGER_8 is 2
   kind_tie:  INTEGER_8 is 3

end
