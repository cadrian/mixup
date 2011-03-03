deferred class MIXUP_NOTE

inherit
   MIXUP_MUSIC

feature {ANY}
   -- 64th
   duration_64  : INTEGER is   4
   duration_64p : INTEGER is   6
   duration_64pp: INTEGER is   7

   -- 32th
   duration_32  : INTEGER is   8
   duration_32p : INTEGER is  12
   duration_32pp: INTEGER is  14

   -- 16th
   duration_16  : INTEGER is  16
   duration_16p : INTEGER is  24
   duration_16pp: INTEGER is  28

   -- crochet (or 8th)
   duration_8   : INTEGER is  32
   duration_8p  : INTEGER is  48
   duration_8pp : INTEGER is  56

   -- quarter
   duration_4   : INTEGER is  64
   duration_4p  : INTEGER is  96
   duration_4pp : INTEGER is 112

   -- half
   duration_2   : INTEGER is 128
   duration_2p  : INTEGER is 192
   duration_2pp : INTEGER is 224

   -- whole
   duration_1   : INTEGER is 256
   duration_1p  : INTEGER is 384
   duration_1pp : INTEGER is 448

feature {ANY}
   commit is
      do
      end

feature {MIXUP_VOICE}
   frozen consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

end
