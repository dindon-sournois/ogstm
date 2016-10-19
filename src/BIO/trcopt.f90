
      SUBROUTINE trcopt
!!!---------------------------------------------------------------------
!!!
!!!                       ROUTINE trcopt
!!!                     ******************

       USE myalloc
       USE myalloc_mpp
       USE OPT_mem
       IMPLICIT NONE


!!! local declarations
!!! ==================

      REAL(8) conversion
#if defined key_trc_nnpzddom || defined key_trc_npzd || key_trc_bfm

      INTEGER :: ji,jj,jk
      INTEGER :: mytid, ntids! omp variables

#ifdef __OPENMP1
      INTEGER ::  omp_get_thread_num, omp_get_num_threads, omp_get_max_threads
      EXTERNAL :: omp_get_thread_num, omp_get_num_threads, omp_get_max_threads
#endif


#ifdef __OPENMP1
      ntids = omp_get_max_threads() ! take the number of threads
      mytid = -1000000

#else
      ntids = 1
      mytid = 0
#endif



      trcoptparttime = MPI_WTIME() ! cronometer-start

      conversion = 0.50/0.217 ! Conversion Einstein to Watt  E2W=0.217

! vertical slab
! ===============

      DO jj = 1,jpj,ntids
!!!$omp parallel default(none) private(mytid,ji,jk)
!!!$omp&                       shared(jj,jpk,jpj,jpi,xpar,conversion,kef,e3t,qsr)
#ifdef __OPENMP1
         mytid  = omp_get_thread_num()  ! take the thread ID
#endif
      if (mytid+jj.le.jpj) then


! 1. determination of surface irradiance

        DO ji = 1,jpi

          zpar0m(ji)          = qsr(ji,mytid+jj)*conversion
          zpar100(ji)         = zpar0m(ji)*0.01
          xpar(ji,mytid+jj,1) = zpar0m(ji)
          zpar(ji,1)          = zpar0m(1)
          xEPS(ji,1)          = kef(ji,mytid+jj)

        END DO

!! 2. determination of xpar
!! ------------------------

        DO jk = 2,jpk
          DO ji = 1,jpi

            xEPS(ji,jk)          = kef(ji,mytid+jj)
            xEPS(ji,jk)          = max(xEPS(ji,jk),1.D-15) ! avoid denormalized number
            xpar(ji,mytid+jj,jk) = xpar(ji,mytid+jj,jk-1) *exp(-1. * xEPS(ji,jk-1)* e3t(ji,jj,jk-1))
            xpar(ji,mytid+jj,jk) = max(xpar(ji,mytid+jj,jk),1.D-15) ! avoid denormalized number

          END DO
        END DO

        DO jk = 1,jpk
          DO ji = 1,jpi
            !a=xpar(ji,mytid+jj,jk); xpar(ji,mytid+jj,jk) = max(a*exp(- xEPS(ji,jk)* 0.5D+00* e3t(jk) ), 1.D-15);
            xpar(ji,mytid+jj,jk) = xpar(ji,mytid+jj,jk) * exp(- xEPS(ji,jk)* 0.5D+00* e3t(ji,jj,jk) )
            xpar(ji,mytid+jj,jk) = max(xpar(ji,mytid+jj,jk),1.D-15)
          END DO
        END DO

      endif
!!!$omp end parallel
      END DO

       trcoptparttime = MPI_WTIME() - trcoptparttime ! cronometer-stop
       trcopttottime = trcopttottime + trcoptparttime

#else

!!    No optical model

#endif

      END SUBROUTINE trcopt