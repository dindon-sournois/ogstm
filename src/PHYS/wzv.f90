      SUBROUTINE wzv ()
!---------------------------------------------------------------------
!
!                       ROUTINE wzv
!                     ***************
!
!  Purpose :
!  ---------
!	Compute the now vertical velocity after the array swap.
!
!   Method :
!   -------
!	Using the incompressibility hypothesis, the vertical velocity
!	is computed by integrating the horizontal divergence from the
!	bottom to the surface.
!	The boundary conditions are w=0 at the bottom (no flux) and
!	w=0 at the sea surface (rigid lid).
!
!	macro-tasked on vertical slab (jj-loop)
!
!   Input :
!   ------
!      argument
!              ktask       : task identificator
!              kt          : time step
!      common
!              /comcoh/    : scale factors
!		/comtsk/    : multitasking
!              /comnow/    : present fields (now)
!
!   Output :

! parameters and commons
! ======================

       USE myalloc
       IMPLICIT NONE

!----------------------------------------------------------------------
! local declarations
! ==================
      INTEGER ji, jj, jk

! Vertical slab
! =============

      DO jj = 1, jpj

! 1. Surface and bottom boundary condition: w=0 (rigid lid and no flux)
! ----------------------------------------

        DO ji = 1, jpi
          wdta(ji,jj, 1 ,2) = 0.e0
          wdta(ji,jj,jpk,2) = 0.e0
        END DO  


! 2. Computation from the bottom
! ------------------------------

        DO jk = jpkm1, 1, -1
          DO ji = 1, jpi
            wdta(ji,jj,jk,2) = wdta(ji,jj,jk+1,2) - e3t(ji,jj,jk)*hdivn(ji,jj,jk)
!           wn(ji,jj,jk) = wn(ji,jj,jk+1) - e3t(ji,jj,jk)*hdivn(ji,jj,jk)
          END DO 
        END DO

      END DO

      END SUBROUTINE wzv