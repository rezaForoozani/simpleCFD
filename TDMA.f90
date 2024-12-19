!============================================================================
!===============Thomas Algorithm for Linear algebraic system ================
!============================================================================
Subroutine SY(IL,IU,BB,DD,AA,CC)
implicit none
integer LP,IL,IU,i,j
real(8) :: AA(IU), BB(IU), CC(IU), DD(IU),R
LP = IL + 1
Do i = LP, IU
    R = BB(i) / DD(i-1)
    DD(i) = DD(i) - R * AA(i-1)
    CC(i) = CC(i) - R * CC(i-1)
Enddo
CC(IU) = CC(IU) / DD(IU)
Do i = LP, IU
    J = IU - i + IL
    CC(J) = (CC(J) - AA(J) * CC(J+1)) / DD(J)
Enddo    
End Subroutine SY
!-----------------------------------------------------------------------------