
      INTEGER, parameter :: jptra_b = 59

      INTEGER, parameter :: jptra_var_b    = 1

      INTEGER, parameter :: jptra_flux_b   = 1

      INTEGER, parameter :: jptra_dia_b    = jptra_var_b + jptra_flux_b

      INTEGER, parameter :: jptra_dia_b_2d = 175


C State variables

      integer,parameter ::
     &   ppG3c=1,
     &   ppG3h=2,
     &   ppG13c=3,
     &   ppG13h=4,
     &   ppG23c=5,
     &   ppG23h=6,
     &   ppY1c=7,
     &   ppY1n=8,
     &   ppY1p=9,
     &   ppY2c=10,
     &   ppY2n=11,
     &   ppY2p=12,
     &   ppY3c=13,
     &   ppY3n=14,
     &   ppY3p=15,
     &   ppY4c=16,
     &   ppY4n=17,
     &   ppY4p=18,
     &   ppY5c=19,
     &   ppY5n=20,
     &   ppY5p=21,
     &   ppQ6c=22,
     &   ppQ6n=23,
     &   ppQ6p=24,
     &   ppQ6s=25,
     &   ppQ5c=26,
     &   ppQ5n=27,
     &   ppQ5p=28,
     &   ppQ1c=29,
     &   ppQ1n=30,
     &   ppQ1p=31,
     &   ppQ11c=32,
     &   ppQ11n=33,
     &   ppQ11p=34,
     &   ppH1c=35,
     &   ppH1n=36,
     &   ppH1p=37,
     &   ppH2c=38,
     &   ppH2n=39,
     &   ppH2p=40,
     &   ppK1p=41,
     &   ppK11p=42,
     &   ppK21p=43,
     &   ppK4n=44,
     &   ppK14n=45,
     &   ppK24n=46,
     &   ppK6r=47,
     &   ppK16r=48,
     &   ppK26r=49,
     &   ppK3n=50,
     &   ppK5s=51,
     &   ppG2o=52,
     &   ppG4n=53,
     &   ppD1m=54,
     &   ppD2m=55,
     &   ppD6m=56,
     &   ppD7m=57,
     &   ppD8m=58,
     &   ppD9m=59


C       diagnostic indexes

      integer,parameter ::
     &   ppDIA_B_1=1


C       diagnostic 2D indexes

      integer,parameter ::
     &   ppsidiss=1,
     &   ppM1p=2,
     &   ppM11p=3,
     &   ppM21p=4,
     &   ppM4n=5,
     &   ppM14n=6,
     &   ppM24n=7,
     &   ppM3n=8,
     &   ppM5s=9,
     &   ppM6r=10,
     &   ppRI_Fc=11,
     &   ppRI_Fn=12,
     &   ppRI_Fp=13,
     &   ppRI_Fs=14,
     &   ppZI_Fc=15,
     &   ppZI_Fn=16,
     &   ppZI_Fp=17,
     &   ppZI_Fs=18,
     &   ppjZIY3c=19,
     &   ppjRIY3c=20,
     &   ppjRIY3n=21,
     &   ppjRIY3p=22,
     &   ppjRIY3s=23,
     &   ppDepth_Ben=24,
     &   ppETW_Ben=25,
     &   ppERHO_Ben=26,
     &   ppESW_Ben=27,
     &   ppO2o_Ben=28,
     &   ppN1p_Ben=29,
     &   ppN3n_Ben=30,
     &   ppN4n_Ben=31,
     &   ppN5s_Ben=32,
     &   ppN6r_Ben=33,
     &   ppsediR6_Ben=34,
     &   ppjK4K3n=35,
     &   ppjK3G4n=36,
     &   ppjK31K21p=37,
     &   ppjK34K24n=38,
     &   ppjK13K3n=39,
     &   ppjK15K5s=40,
     &   ppjK36K26r=41,
     &   ppDICae=42,
     &   ppDICan=43,
     &   ppO3c_Ben=44,
     &   ppO3h_Ben=45,
     &   ppAcae=46,
     &   ppAcan=47,
     &   pppHae=48,
     &   pppHan=49,
     &   pppCO2ae=50,
     &   pppCO2an=51,
     &   pptotbenc=52,
     &   pptotbenn=53,
     &   pptotbenp=54,
     &   pptotbens=55,
     &   pprrBTo=56,
     &   pprrATo=57,
     &   ppreBTn=58,
     &   ppreBTp=59,
     &   ppreATn=60,
     &   ppreATp=61,
     &   ppturenh=62,
     &   ppirrenh=63,
     &   ppshiftD1m=64,
     &   ppshiftD2m=65,
     &   ppjG2K3o=66,
     &   ppjG2K7o=67,
     &   pppdenit=68,
     &   pppnit=69,
     &   pppanox=70,
     &   pppsid=71,
     &   pppdepo=72,
     &   ppcmin=73,
     &   ppnmin=74,
     &   pppmin=75,
     &   ppjsurO2o=76,
     &   ppjsurN1p=77,
     &   ppjsurN3n=78,
     &   ppjsurN4n=79,
     &   ppjsurO4n=80,
     &   ppjsurN5s=81,
     &   ppjsurN6r=82,
     &   ppjsurB1c=83,
     &   ppjsurB1n=84,
     &   ppjsurB1p=85,
     &   ppjsurP1c=86,
     &   ppjsurP1n=87,
     &   ppjsurP1p=88,
     &   ppjsurP1l=89,
     &   ppjsurP1s=90,
     &   ppjsurP2c=91,
     &   ppjsurP2n=92,
     &   ppjsurP2p=93,
     &   ppjsurP2l=94,
     &   ppjsurP3c=95,
     &   ppjsurP3n=96,
     &   ppjsurP3p=97,
     &   ppjsurP3l=98,
     &   ppjsurP4c=99,
     &   ppjsurP4n=100,
     &   ppjsurP4p=101,
     &   ppjsurP4l=102,
     &   ppjsurZ3c=103,
     &   ppjsurZ3n=104,
     &   ppjsurZ3p=105,
     &   ppjsurZ4c=106,
     &   ppjsurZ4n=107,
     &   ppjsurZ4p=108,
     &   ppjsurZ5c=109,
     &   ppjsurZ5n=110,
     &   ppjsurZ5p=111,
     &   ppjsurZ6c=112,
     &   ppjsurZ6n=113,
     &   ppjsurZ6p=114,
     &   ppjsurR1c=115,
     &   ppjsurR1n=116,
     &   ppjsurR1p=117,
     &   ppjsurR2c=118,
     &   ppjsurR3c=119,
     &   ppjsurR6c=120,
     &   ppjsurR6n=121,
     &   ppjsurR6p=122,
     &   ppjsurR6s=123,
     &   ppjsurO3c=124,
     &   ppjsurO3h=125,
     &   ppjbotO2o=126,
     &   ppjbotN1p=127,
     &   ppjbotN3n=128,
     &   ppjbotN4n=129,
     &   ppjbotO4n=130,
     &   ppjbotN5s=131,
     &   ppjbotN6r=132,
     &   ppjbotB1c=133,
     &   ppjbotB1n=134,
     &   ppjbotB1p=135,
     &   ppjbotP1c=136,
     &   ppjbotP1n=137,
     &   ppjbotP1p=138,
     &   ppjbotP1l=139,
     &   ppjbotP1s=140,
     &   ppjbotP2c=141,
     &   ppjbotP2n=142,
     &   ppjbotP2p=143,
     &   ppjbotP2l=144,
     &   ppjbotP3c=145,
     &   ppjbotP3n=146,
     &   ppjbotP3p=147,
     &   ppjbotP3l=148,
     &   ppjbotP4c=149,
     &   ppjbotP4n=150,
     &   ppjbotP4p=151,
     &   ppjbotP4l=152,
     &   ppjbotZ3c=153,
     &   ppjbotZ3n=154,
     &   ppjbotZ3p=155,
     &   ppjbotZ4c=156,
     &   ppjbotZ4n=157,
     &   ppjbotZ4p=158,
     &   ppjbotZ5c=159,
     &   ppjbotZ5n=160,
     &   ppjbotZ5p=161,
     &   ppjbotZ6c=162,
     &   ppjbotZ6n=163,
     &   ppjbotZ6p=164,
     &   ppjbotR1c=165,
     &   ppjbotR1n=166,
     &   ppjbotR1p=167,
     &   ppjbotR2c=168,
     &   ppjbotR3c=169,
     &   ppjbotR6c=170,
     &   ppjbotR6n=171,
     &   ppjbotR6p=172,
     &   ppjbotR6s=173,
     &   ppjbotO3c=174,
     &   ppjbotO3h=175

