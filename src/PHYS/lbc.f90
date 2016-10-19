
      SUBROUTINE lbc ( ptab, ktype, ksgn,kdoloop, kjstart, kjpend, kstep )
!!!---------------------------------------------------------------------
!!!
!!!                       ROUTINE lbc
!!!                     ***************
!!!
!!!  Purpose :
!!!  --------
!!!      Insure the lateral boundary conditions in non mpp configuration
!!!
!!   Method :
!!   -------
!!
!!   Input :
!!   ------
!!      argument
!!              ptab            : variable array
!!              ktype           : define the nature of the grid-point
!!                  at which ptab is defined
!!                  = 1 ,  T- and W-points
!!                  = 2 ,  U-point
!!                  = 3 ,  V-point
!!                  = 4 ,  F-point
!!        ksgn        : control of the sign change
!!                  = 0 , the sign is modified following
!!                  the type of b.c. used
!!                  = 1 , the sign of the field is un-
!!                  changed at the boundaries
!!              kdoloop         : = 1  macrostaked on jk-slabs for
!!                       2D or 3D arrays
!!                                = 2  macrostaked on jj-slabs for
!!                       a 3D array (jpk,jpj,jpi)
!!                                = 3  macrostaked on jj-slabs for
!!                       a 2D array (jpi,jpj)
!!        kjstart        : starting index of multitasked do-loop
!!        kjpend         : ending index of multitasked do-loop
!!        kstep          : step of multitasked do-loop
!!
!!   Output :
!!   -------
!!      argument
!!              ptab            : variable array with disired lateral
!!                  boundary conditions

      USE myalloc
      IMPLICIT NONE

!! local declarations
!! ==================

      INTEGER ktype, ksgn, kdoloop, kjstart, kjpend, kstep
      REAL(8) ptab(jpk,jpj,jpi)
#ifdef key_mpp





      REAL(8) zsgn


      INTEGER ijt, iju
      INTEGER ji, jj, jk
!! 0. Sign setting
!! ---------------

      IF (ksgn.EQ.0) THEN
          zsgn = -1.
        ELSE
          zsgn =  1.
      ENDIF
!!
      IF (kdoloop.EQ.1) THEN
!!
!!
!!     Horizontal slab
!!     ===============
!!
          DO jk = kjstart, kjpend, kstep
!!
!!
!! 1. East-West boundary conditions
!! --------------------------------
!!
            IF ( nperio.EQ.1 .OR. nperio.EQ.4 ) THEN
!! ... cyclic
                DO jj = 1, jpj
                  ptab( 1 ,jj,jk) = ptab(jpim1,jj,jk)
                  ptab(jpi,jj,jk) = ptab(  2  ,jj,jk)
                END DO
              ELSE
!! ... closed
                IF ( ktype.EQ.4 ) THEN
                    DO jj = 1, jpj
                      ptab(jpi,jj,jk) = 0.e0
                    END DO
                  ELSE
                    DO jj = 1, jpj
                      ptab( 1 ,jj,jk) = 0.e0
                      ptab(jpi,jj,jk) = 0.e0
                    END DO
                ENDIF
            ENDIF
!!
!! 2. North-South boundary conditions
!! ----------------------------------
!!
            IF ( nperio.EQ.2 ) THEN
!! ... south symmetric
                IF ( ktype.EQ.1 .OR. ktype.EQ.2 ) THEN
                    DO ji = 1, jpi
                      ptab(ji, 1 ,jk) = ptab(ji,3,jk)
                      ptab(ji,jpj,jk) = 0.e0
                    END DO
                  ELSEIF ( ktype.EQ.3 .OR. ktype.EQ.4 ) THEN
                    DO ji = 1, jpi
                      ptab(ji, 1 ,jk) = zsgn * ptab(ji,2,jk)
                      ptab(ji,jpj,jk) = 0.e0
                    END DO
                ENDIF
              ELSEIF ( nperio.EQ.3 .OR. nperio.EQ.4 ) THEN
!! ... north fold
                ptab(1,jpj,jk)=0.e0
                ptab(jpi,jpj,jk)=0.e0
                IF ( ktype.EQ.1 ) THEN
                    DO ji = 2, jpi
                      ijt=jpi-ji+2
                      ptab(ji, 1 ,jk) = 0.e0
                      ptab(ji,jpj,jk) = zsgn * ptab(ijt,jpj-2,jk)
                    END DO
                    DO ji = jpi/2+1, jpi
                      ijt=jpi-ji+2
                      ptab(ji,jpjm1,jk) = zsgn * ptab(ijt,jpjm1,jk)
                    END DO
                  ELSEIF ( ktype.EQ.2 ) THEN
                    DO ji = 1, jpi-1
                      iju=jpi-ji+1
                      ptab(ji, 1 ,jk) = 0.e0
                      ptab(ji,jpj,jk) = zsgn * ptab(iju,jpj-2,jk)
                    END DO
                    DO ji = jpi/2, jpi-1
                      iju=jpi-ji+1
                      ptab(ji,jpjm1,jk) = zsgn * ptab(iju,jpjm1,jk)
                    END DO
                  ELSEIF ( ktype.EQ.3 ) THEN
                    DO ji = 2, jpi
                      ijt=jpi-ji+2
                      ptab(ji, 1 ,jk) = 0.e0
                      ptab(ji,jpj-1,jk) = zsgn * ptab(ijt,jpj-2,jk)
                      ptab(ji,jpj  ,jk) = zsgn * ptab(ijt,jpj-3,jk)
                    END DO
                  ELSEIF ( ktype.EQ.4 ) THEN
                    DO ji = 1, jpi-1
                      iju=jpi-ji+1
!!                      ptab(ji, 1 ,jk) = 0.e0
                      ptab(ji,jpj-1,jk) = ptab(iju,jpj-2,jk)
                      ptab(ji,jpj  ,jk) = ptab(iju,jpj-3,jk)
                    END DO
                ENDIF
              ELSE
!! ... closed
                IF ( ktype.EQ.4 ) THEN
                    DO ji = 1, jpi
                      ptab(ji,jpj,jk) = 0.e0
                    END DO
                  ELSE
                    DO ji = 1, jpi
                      ptab(ji, 1 ,jk) = 0.e0
                      ptab(ji,jpj,jk) = 0.e0
                    END DO
                ENDIF
            ENDIF
!!
!!
!!     End of slab
!!     ===========
!!
           END DO
!!
!!
         ELSEIF ( kdoloop.EQ.2 ) THEN
!!
!!
!!     Vertical slab
!!     =============
!!
          DO jj = kjstart, kjpend, kstep
!!
!! 1. East-West boundary conditions
!! --------------------------------
!!
            IF ( nperio.EQ.1 .OR. nperio.EQ.4 ) THEN
!! ... cyclic
                DO jk = 1, jpk
                  ptab( 1 ,jj,jk) = ptab(jpim1,jj,jk)
                  ptab(jpi,jj,jk) = ptab(  2  ,jj,jk)
                END DO
              ELSE
!! ... closed
                IF ( ktype.EQ.4 ) THEN
                    DO jk = 1, jpk
                      ptab(jpi,jj,jk) = 0.e0
                    END DO
                  ELSE
                    DO jk = 1, jpk
                      ptab( 1 ,jj,jk) = 0.e0
                      ptab(jpi,jj,jk) = 0.e0
                    END DO
                ENDIF
            ENDIF
!!
!!
!! 2. North-South boundary conditions ( only for row jj = 3 or = 2 )
!! ----------------------------------
!!
            IF ( nperio.EQ.2 ) THEN
!! ... south symmetric
                IF ( ktype.EQ.1 .OR. ktype.EQ.2 .AND. jj.EQ.3 ) THEN
                    DO jk = 1, jpk
                      DO ji = 1, jpi
                        ptab(ji, 1 ,jk) = ptab(ji,3,jk)
                        ptab(ji,jpj,jk) = 0.e0
                      END DO
                    END DO
                  ELSEIF ( ktype.EQ.3 .OR. ktype.EQ.4.AND. jj.EQ.2 ) THEN
                    DO jk = 1, jpk
                      DO ji = 1, jpi
                        ptab(ji, 1 ,jk) = zsgn * ptab(ji,2,jk)
                        ptab(ji,jpj,jk) = 0.e0
                      END DO
                    END DO
                ENDIF
              ELSEIF ( nperio.EQ.3 .OR. nperio.EQ.4 ) THEN
!! ... north fold
                IF (jj .EQ. jpj-3) THEN
                    DO jk = 1, jpk
                      ptab(1,jpj,jk)=0.e0
                      ptab(jpi,jpj,jk)=0.e0
                    END DO
                ENDIF
                IF ( ktype.EQ.1 .AND. jj.EQ.jpj-2 ) THEN
                     DO jk = 1, jpk
                       DO ji = 2, jpi
                         ijt=jpi-ji+2
                         ptab(ji, 1 ,jk) = 0.e0
                         ptab(ji,jpj,jk) = zsgn * ptab(ijt,jpj-2,jk)
                       END DO
                     END DO
                   ELSEIF ( ktype.EQ.1 .AND. jj.EQ.jpjm1 ) THEN
                     DO jk = 1, jpk
                       DO ji = jpi/2+1, jpi
                         ijt=jpi-ji+2
                         ptab(ji,jpjm1,jk) = zsgn * ptab(ijt,jpjm1,jk)
                       END DO
                     END DO
                   ELSEIF ( ktype.EQ.2 .AND. jj.EQ.jpj-2 ) THEN
                     DO jk = 1, jpk
                       DO ji = 1, jpi-1
                         iju=jpi-ji+1
                         ptab(ji, 1 ,jk) = 0.e0
                         ptab(ji,jpj,jk) = zsgn * ptab(iju,jpj-2,jk)
                       END DO
                     END DO
                   ELSEIF ( ktype.EQ.2 .AND. jj.EQ.jpjm1 ) THEN
                     DO jk = 1, jpk
                       DO ji = jpi/2, jpi-1
                         iju=jpi-ji+1
                         ptab(ji,jpjm1,jk) = zsgn * ptab(iju,jpjm1,jk)
                       END DO
                    END DO
                  ELSEIF ( ktype.EQ.3 .AND. jj.EQ.jpj-3 ) THEN
                    DO jk = 1, jpk
                      DO ji = 2, jpi
                        ijt=jpi-ji+2
                        ptab(ji, 1 ,jk) = 0.e0
                        ptab(ji,jpj,jk) = zsgn * ptab(ijt,jpj-3,jk)
                      END DO
                    END DO
                  ELSEIF ( ktype.EQ.3 .AND. jj.EQ.jpj-2 ) THEN
                    DO jk = 1, jpk                    
                      DO ji = 2, jpi
                        ijt=jpi-ji+2
                        ptab(ji,jpj-1,jk) = zsgn * ptab(ijt,jpj-2,jk)
                      END DO
                    END DO
                  ELSEIF ( ktype.EQ.4 .AND. jj.EQ.jpj-3 ) THEN
                    DO jk = 1, jpk                       
                      DO ji = 1, jpi-1
                        iju=jpi-ji+1
                        ptab(ji,jpj,jk) =  ptab(iju,jpj-3,jk)
                      END DO
                    END DO
                  ELSEIF ( ktype.EQ.4 .AND. jj.EQ.jpj-2 ) THEN
                    DO jk = 1, jpk                     
                      DO ji = 1, jpi-1
                        iju=jpi-ji+1
                        ptab(ji,jpj-1,jk) =  ptab(iju,jpj-2,jk)
                      END DO
                    END DO
                ENDIF
              ELSEIF( jj.EQ.2 ) THEN
!! ... closed
                DO jk = 1, jpk
                  DO ji = 1, jpi
                    ptab(ji, 1 ,jk) = 0.e0
                    ptab(ji,jpj,jk) = 0.e0
                  END DO
                END DO
            ENDIF
!!
!!
!!     End of slab
!!     ===========
!!
           END DO
!!
         ELSEIF ( kdoloop.EQ.3 ) THEN
!!
!!
!!     Vertical slab for a 2D array (jpi,jpj)
!!     ============================
!!
          DO jj = kjstart, kjpend, kstep
!!
!! 1. East-West boundary conditions
!! --------------------------------
!!
            IF ( nperio.EQ.1 .OR. nperio.EQ.4 ) THEN
!! ... cyclic
                ptab( 1 ,jj,1) = ptab(jpim1,jj,1)
                ptab(jpi,jj,1) = ptab(  2  ,jj,1)
              ELSE
!! ... closed
                IF ( ktype.EQ.4 ) THEN
                    ptab(jpi,jj,1) = 0.e0
                  ELSE
                    ptab( 1 ,jj,1) = 0.e0
                    ptab(jpi,jj,1) = 0.e0
                ENDIF
            ENDIF
!!
!!
!! 2. North-South boundary conditions ( only for row jj = 3 or = 2 )
!! ----------------------------------
!!
            IF ( nperio.EQ.2 ) THEN
!! ... south symmetric
                IF ( ktype.EQ.1 .OR. ktype.EQ.2 .AND. jj.EQ.3 ) THEN
                    DO ji = 1, jpi
                      ptab(ji, 1 ,1) = ptab(ji,3,1)
                      ptab(ji,jpj,1) = 0.e0
                    END DO
                  ELSEIF ( ktype.EQ.3 .OR. ktype.EQ.4.AND. jj.EQ.2 ) THEN
                    DO ji = 1, jpi
                      ptab(ji, 1 ,1) = zsgn * ptab(ji,2,1)
                      ptab(ji,jpj,1) = 0.e0
                    END DO
                ENDIF
              ELSEIF ( nperio.EQ.3 .OR. nperio.EQ.4 ) THEN
!! ... north fold
                IF ( jj.EQ. jpj-3) THEN
                    ptab(1,jpj,1)=0.e0
                    ptab(jpi,jpj,1)=0.e0
                ENDIF 
                IF ( ktype.EQ.1 .AND. jj.EQ.jpj-2 ) THEN
                    DO ji = 2, jpi
                      ijt=jpi-ji+2
                      ptab(ji, 1 ,1) = 0.e0
                      ptab(ji,jpj,1) = zsgn * ptab(ijt,jpj-2,1)
                    END DO
                  ELSEIF ( ktype.EQ.1 .AND. jj.EQ.jpjm1 ) THEN
                    DO ji = jpi/2+1, jpi
                      ijt=jpi-ji+2
                      ptab(ji,jpjm1,1) = zsgn * ptab(ijt,jpjm1,1)
                    END DO
                  ELSEIF ( ktype.EQ.2 .AND. jj.EQ.jpj-2 ) THEN
                    DO ji = 1, jpi-1
                      iju=jpi-ji+1
                      ptab(ji, 1 ,1) = 0.e0
                      ptab(ji,jpj,1) = zsgn * ptab(iju,jpj-2,1)
                    END DO
                  ELSEIF ( ktype.EQ.2 .AND. jj.EQ.jpjm1 ) THEN
                    DO ji = jpi/2, jpi-1
                      iju=jpi-ji+1
                      ptab(ji,jpjm1,1) = zsgn * ptab(iju,jpjm1,1)
                    END DO
                  ELSEIF ( ktype.EQ.3 .AND. jj.EQ.jpj-3 ) THEN
                    DO ji = 2, jpi
                      ijt=jpi-ji+2
                      ptab(ji, 1 ,1) = 0.e0
                      ptab(ji,jpj,1) = zsgn * ptab(ijt,jpj-3,1)
                    END DO
                  ELSEIF ( ktype.EQ.3 .AND. jj.EQ.jpj-2 ) THEN
                    DO ji = 2, jpi
                      ijt=jpi-ji+2
                      ptab(ji,jpj-1,1) = zsgn * ptab(ijt,jpj-2,1)
                    END DO
                  ELSEIF ( ktype.EQ.4 .AND. jj.EQ.jpj-3 ) THEN
                    DO ji = 1, jpi-1
                      iju=jpi-ji+1
                      ptab(ji,jpj,1) =  ptab(iju,jpj-3,1)
                    END DO
                  ELSEIF ( ktype.EQ.4 .AND. jj.EQ.jpj-2 ) THEN
                    DO ji = 1, jpi-1
                      iju=jpi-ji+1
                      ptab(ji,jpj-1,1) =  ptab(iju,jpj-2,1)
                    END DO
                ENDIF
              ELSEIF( jj.EQ.2 ) THEN
!! ... closed
                DO ji = 1, jpi
                  ptab(ji, 1 ,1) = 0.e0
                  ptab(ji,jpj,1) = 0.e0
                END DO
            ENDIF
!!
!!
!!     End of slab
!!     ===========
!!
           END DO
!!
         ELSE
!!
!!
!! 3. E-R-R-O-R
!! ------------
!!
           IF(lwp) WRITE(numout,*) ' '
           IF(lwp) WRITE(numout,*) ' lbc: e r r o r in kdoloop argument'
           IF(lwp) WRITE(numout,*) '      we stop'
           STOP
       ENDIF
!!
#  else
!!      mpp computation the lateral boundary conditions
!!
!!
#endif
!!
      RETURN
      END