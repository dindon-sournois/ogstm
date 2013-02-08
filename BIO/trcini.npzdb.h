C $Id: trcini.npzdb.h,v 1.2 2009-09-11 09:20:56 cvsogs01 Exp $
CCC---------------------------------------------------------------------
CCC
CCC                        trcini.npzd.h
CCC                       ***************
CCC
CCC  purpose :
CCC  ---------
CCC     special initialisation for NPZD model
CCC
CCC  modifications :
CC   -------------
CC      original    : 99-09 (M. Levy) 
CC      additions   : 00-12 (E. Kestenare) add sediment computations
CCC
CCC---------------------------------------------------------------------
CCC  opa8, ipsl (11/96)
CCC---------------------------------------------------------------------
CCC local variables
      REAL(8) ztest
C
C 2. initialization of field for optical model
C --------------------------------------------
C
      DO jj=1,jpj
        DO ji=1,jpi
          xze(ji,jj)=5.
        END DO
      END DO

      DO jk=1,jpk
        DO jj=1,jpj
          DO ji=1,jpi
            xpar(ji,jj,jk)=0.
          END DO
        END DO
      END DO