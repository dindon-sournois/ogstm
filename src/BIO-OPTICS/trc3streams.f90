
      SUBROUTINE trc3streams(datestring)
!!!---------------------------------------------------------------------
!!!
!!!                       ROUTINE trc3streams
!!!                     ******************

       USE myalloc
       USE mpi
       USE OPT_mem
       USE TIME_MANAGER

       IMPLICIT NONE

       character(LEN=17), INTENT(IN) ::  datestring

!!! local declarations
!!! ==================

#if defined key_trc_nnpzddom || defined key_trc_npzd || key_trc_bfm

      INTEGER :: jk,jj,ji,jl,bottom
      INTEGER :: day_of_year
      INTEGER :: MODE ! 0-exact, 1-approx
      INTEGER :: year, month, day, ihr
      INTEGER :: it_actual
      CHARACTER(LEN=20) :: V_POSITION     
      double precision :: solz(jpj,jpi), rmud(jpj,jpi)
      double precision :: Edz(jpk,nlt),Esz(jpk,nlt),Euz(jpk,nlt)
      double precision :: E(3,jpk+1,nlt)
      double precision :: PARz(jpk,nchl+1)
      double precision :: CHLz(jpk,nchl),CDOMz(jpk),POCz(jpk)
      double precision :: Eu_0m(nlt)
      double precision :: zgrid(jpk+1)
      double precision :: sec


      trcoptparttime = MPI_WTIME() ! cronometer-start

! Where to compute irradiance options are
!- BOTTOM
!- MID
!- AVERAGE

      V_POSITION = "AVERAGE"

! Compute RT every hour

      if (datestring .eq. DATESTART) then
         call read_date_string(datestring, year, month, day, sec)
         it_check = int(sec/3600.d0) 
      endif

      call read_date_string(datestring, year, month, day, sec)

      it_actual = int(sec/3600.d0)

      ihr       = it_actual ! from 0 to 23 
      
      if ( (it_actual .eq. it_check) .and. (datestring.ne.DATESTART)) then 

         if (lwp) write(*,*) 'Skip computing RT at : ', datestring

         trcoptparttime = MPI_WTIME() - trcoptparttime ! cronometer-stop

         trcopttottime = trcopttottime + trcoptparttime

         return ! no need to compute RT

      else

         it_check = it_actual

      endif

      call tau2julianday(datestringToTAU(datestring), deltaT, day_of_year)
     
      if (lwp) write(*,*) 'day_of_year', day_of_year

      call sfcsolz(year, day_of_year, ihr, solz) 

      call getrmud(solz,rmud)


      PARz(:,:) = 0.0D0
! Start computing  RT when and where needed

      do ji=1,jpi
         do jj=1,jpj

! Controls to avoid  calc where no biology
             if (bfmmask(1,jj,ji) == 0) CYCLE
         

             bottom = mbathy(jj,ji)
             bottom = min(bottom,37) ! Stop at approx 500 mt

!            MODE = 0 ! exact solution
!            MODE = 0 ! exact solution
!            MODE = 1 ! approximate solution
             MODE = 2 ! library solution

             Ed_0m(:,jj,ji) =5.0D0
             Es_0m(:,jj,ji) =5.0D0

             RMU(jj,ji) = rmud(jj,ji)

       
             if ((maxval(Ed_0m(:,jj,ji)) < 0.0001d0) .AND. (maxval(Es_0m(:,jj,ji))< 0.0001d0)) then
  
                 Ed(1,jj,ji,:) = Ed_0m(:,jj,ji)
                 Es(1,jj,ji,:) = Es_0m(:,jj,ji)

                 if (MODE .EQ. 0)  Eu(1,jj,ji,:) = 0.0d0
                 if (MODE .EQ. 1)  Eu(1,jj,ji,:) = -1.0d0
  
                 Ed(2:bottom,jj,ji,:) = 0.0001d0
                 Es(2:bottom,jj,ji,:) = 0.0001d0
                 Eu(2:bottom,jj,ji,:) = 0.0001d0
                 PAR(1:bottom,jj,ji,:) = 0.0001d0

             else
             
                 CHLz(1:bottom,1) = trn(1:bottom,jj,ji,ppP1l)
                 CHLz(1:bottom,2) = trn(1:bottom,jj,ji,ppP2l)
                 CHLz(1:bottom,3) = trn(1:bottom,jj,ji,ppP3l)
                 CHLz(1:bottom,4) = trn(1:bottom,jj,ji,ppP4l)
                 write(*,*) 'WARNING: CDOM deactivated' 
                 CDOMz(1:bottom)  = 0.0d0!trn(1:bottom,jj,ji,ppR1l) + trn(1:bottom,jj,ji,ppR2l) + trn(1:bottom,jj,ji,ppR3l)
    
                 POCz(1:bottom)   = trn(1:bottom,jj,ji,ppR6c) 
    
                 IF ( (MODE .EQ. 0) .OR. (MODE .EQ. 1)) then
                     call edeseu(MODE,V_POSITION,bottom,e3w(:,jj,ji),Ed_0m(:,jj,ji),Es_0m(:,jj,ji),CHLz,CDOMz,POCz,rmud(jj,ji),Edz,Esz,Euz,Eu_0m,PARz)
    
                 Ed(1,jj,ji,:) = Ed_0m(:,jj,ji)
                 Es(1,jj,ji,:) = Es_0m(:,jj,ji)
                 Eu(1,jj,ji,:) = Eu_0m(:)
!                write(*,*) "Ed", jl,jk,"=", Ed(1,jj,ji,:)
!                write(*,*) "Es", jl,jk,"=", Es(1,jj,ji,:)
!                write(*,*) "Eu", jl,jk,"=", Eu(1,jj,ji,:)


                 do jl=1, nlt
                    do jk =2, bottom
                        Ed(jk,jj,ji,jl) = Edz(jk-1,jl)
                        Es(jk,jj,ji,jl) = Esz(jk-1,jl)
                        Eu(jk,jj,ji,jl) = Euz(jk-1,jl)
!                       write(*,*) "Ed", jl,jk,"=", Ed(jk,jj,ji,jl)
!                       write(*,*) "Es", jl,jk,"=", Es(jk,jj,ji,jl)
!                       write(*,*) "Eu", jl,jk,"=", Eu(jk,jj,ji,jl)
                    enddo
                 enddo
!                write(*,*) "++++++++++++++++++"

                 do jl=1, nchl+1
                    do jk =1, bottom
                        PAR(jk,jj,ji,jl) = PARz(jk,jl)
!                       write(*,*) "PAR", jl,jk,"=", PAR(jk,jj,ji,jl)
                    enddo
                 enddo
!                write(*,*) "++++++++++++++++++"
!                STOP
                 ENDIF

                 IF (MODE .EQ. 2) then
                     zgrid(1)=0.0D0
                     do jk =1,jpk
                         zgrid(jk+1) = zgrid(jk) + e3w(jk,jj,ji)
!                        write(*,*) "zgrid", jk+1, "=", zgrid(jk+1)
                     enddo
                    
!                    write(*,*) "Bottom", Bottom
!                    write(*,*) "rmud", rmud(jj,ji)

                     E(:,:,:)  = 0.0001d0
                     PARz(:,:) = 0.0001d0

                     call edeseu2(MODE,V_POSITION,bottom,zgrid,Ed_0m(:,jj,ji),Es_0m(:,jj,ji), &
                                  CHLz,CDOMz,POCz,rmud(jj,ji),E(:,1:bottom+1,:),PARz(1:bottom,:))
                
                 do jl=1, nlt
                    do jk =1, bottom+1 ! Defined on w faces (cell's interfaces)
                        Ed(jk,jj,ji,jl) = E(1,jk,jl)
                        Es(jk,jj,ji,jl) = E(2,jk,jl)
                        Eu(jk,jj,ji,jl) = E(3,jk,jl)
!                       write(*,*) "Ed", jl,jk,"=", Ed(jk,jj,ji,jl)
!                       write(*,*) "Es", jl,jk,"=", Es(jk,jj,ji,jl)
!                       write(*,*) "Eu", jl,jk,"=", Eu(jk,jj,ji,jl)
                    enddo
                 enddo
!                write(*,*) "++++++++++++++++++"

                 do jl=1, nchl+1
                    do jk =1, bottom
                        PAR(jk,jj,ji,jl) = PARz(jk,jl)
!                       write(*,*) "PAR", jl,jk,"=", PAR(jk,jj,ji,jl)
                    enddo
                 enddo 
!                write(*,*) "++++++++++++++++++"

!                STOP

                 ENDIF

                 

             endif
            
         enddo
      enddo


      trcoptparttime = MPI_WTIME() - trcoptparttime ! cronometer-stop
      trcopttottime = trcopttottime + trcoptparttime

#else

!!    No optical model

#endif

      END SUBROUTINE trc3streams