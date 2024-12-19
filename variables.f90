module variables
implicit none 
!-------------Decelartion of variables---------------------
Integer i,j,ni,method
parameter (ni=61)
Real(8),Dimension(1:ni) :: X,u,unew,unew1
Real(8)       :: dx,Lx,dt,C,CFL,PI,Time,Residual
character(30) :: filename
real(8)       :: AA(1:ni), BB(1:ni), CC(1:ni), DD(1:ni)
REAL(8)       :: finish , start
!----------------------------------------------------------
end module variables