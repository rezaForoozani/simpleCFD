! 1D Linear Advection Equation
! programmer : Reza Foroozani
! problem Section 6-5 CFD Hoffmann Volume 1
! Last change : 13/jun/2024
program first_order_wave
use variables
implicit none
!-------------input variables-----------------------------------
Lx  = 300d0   ! Length
dt  = 0.001d0 ! time step
C   = 300d0   ! speed of sound
dx = Lx / dble(ni-1)
CFL = C*dt/dx ! Courant–Friedrichs–Lewy number (CFL)
PI  = 4 * atan(1.d0)
Residual = 1.d0
Time  = 0.d0
!---------------Grid Generation---------------------------------
x(1)=0d0
do i=2,ni
    x(i)=x(i-1)+dx    
end do
!--------------Initial Condition--------------------------------
do i=1,ni
    if (x(i) <= 110 .and. x(i) >= 50.0) then
        u(i) = 100.0 * sin(PI * (x(i) - 50.0) / 60.0)    
    else
        u(i)=0.d0
    end if
end do
!-------------Prompt user to select a method--------------------
print*, "Please input one of these methods:"
print*, "1 - Exact solution"
print*, "2 - Explicit Euler"
print*, "3 - Implicit Euler"
print*, "4 - Leapfrog"
print*, "5 - Lax_wendroff"
print*, "6 - MacCormack"
read(*,*) Method    
!-------------main Loop for Transient---------------------------
call cpu_time(start)
do while(Time <= 0.45) 

Time = Time + dt    
 
if (Method == 1) then
call Exact_solution()
end if

if (Method == 2) then
call Explicit_Euler 
end if

if (Method == 3) then
call Implicit_Euler 
end if

if (Method == 4) then
call Leapfrog
end if

if (Method == 5) then
call Lax_wendroff
end if

if (Method == 6) then
call MacCormack
end if

filename = "data.txt"

if (Method>1) print*, "time is : " , Time , "Residual is : " ,Residual  
    
    
end do
!-------------Output--------------------------------------------
call Output
!---------------------------------------------------------------
call cpu_time(finish)
print*,"cpu time is " , finish-start
print*,"press enter to finish"
read(*,*)
Contains
!-------------Subroutines---------------------------------------
!---------------------------------------------------------------
!---------------------------------------------------------------
!-------------Explicit Euler------------------------------------
subroutine Explicit_Euler()
Use variables
implicit none
!
Do i=1,ni
Residual = 0d0
!-------------------implimentation Boubdary Condition-----------
call Boundary_conditions()
!---------------------------------------------------------------
if (i==1) then 
unew(i)  = u(i) - CFL * (u(i+1) - u(i)) ! Forward Differencing
else
unew(i)  = u(i) - CFL * (u(i) - u(i-1)) ! Backward Differencing
end if
Residual = Residual + sqrt(abs(unew(i) - u(i)))
u(i)     = unew(i)
End Do
!
end subroutine Explicit_Euler
!-------------Leapfrog------------------------------------------
subroutine Leapfrog()
Use variables
implicit none
!
Do i=1,ni
Residual = 0d0
!-------------------implimentation Boubdary Condition-----------
call Boundary_conditions()
!---------------------------------------------------------------
if (i==1) then 
unew(i)  = u(i) - CFL * (u(i+1) - u(i)) ! Forward Differencing
else if (i==ni) then
unew(i)  = u(i) - CFL * (u(i) - u(i-1)) ! Backward Differencing    
else
unew(i)  = u(i) - CFL * (u(i+1) - u(i-1))/2 
end if
Residual = Residual + sqrt(abs(unew(i) - u(i)))
u(i)     = unew(i)
End Do
!
end subroutine Leapfrog
!-------------Lax_wendroff--------------------------------------
subroutine Lax_wendroff()
Use variables
implicit none
!
Do i=1,ni
Residual = 0d0
!-------------------implimentation Boubdary Condition-----------
call Boundary_conditions()
!---------------------------------------------------------------
if (i==1) then 
unew(i)  = u(i) - CFL * (u(i+1) - u(i)) ! Forward Differencing
else if (i==ni) then
unew(i)  = u(i) - CFL * (u(i) - u(i-1)) ! Backward Differencing    
else
unew(i)  = u(i)+ - CFL * (u(i+1) - u(i-1))/2 + CFL*CFL/2*(u(i+1)-2*u(i)+u(i-1))
end if
Residual = Residual + sqrt(abs(unew(i) - u(i)))
u(i)     = unew(i)
End Do
!
end subroutine Lax_wendroff
!-------------MacCormack----------------------------------------
subroutine MacCormack()
Use variables
implicit none
!
Do i=1,ni
Residual = 0d0
!-------------------implimentation Boubdary Condition-----------
call Boundary_conditions()
!---------------------------------------------------------------
if (i==1) then 
unew(i)  = u(i) - CFL * (u(i+1) - u(i)) ! Forward Differencing
else if (i==ni) then
unew(i)  = u(i) - CFL * (u(i) - u(i-1)) ! Backward Differencing    
else
! Predictor step (explicit Euler)
unew1(i) = u(i) - CFL * (u(i+1) - u(i)) 
! Corrector step
unew(i) = 0.5 * (u(i) + unew1(i) - CFL * (unew1(i) - unew1(i-1)))
end if
Residual = Residual + sqrt(abs(unew(i) - u(i)))
u(i)     = unew(i)
End Do
!
end subroutine MacCormack
!---------------Boundary Conditions-----------------------------    
subroutine Boundary_conditions()
use variables
implicit none
!
u(1)=0.d0
u(ni)=0.d0
!
end subroutine Boundary_conditions    
!---------------Output-----------------------------------------
Subroutine output()
use variables
implicit none
!
open(1,file=filename)
!write(1,*) 'VARIABLES=',"X",',',"u"
!write(1,*) 'ZONE I=', ni, 'F=POINT'
do i = 1, ni
    write(1,*) x(i), u(i)
end do
close(1)
!
End Subroutine output
!--------------EXact Solution----------------------------------
subroutine Exact_solution()
use variables
implicit none
do i=1,ni
    if (x(i)-C*Time <= 110 .and. x(i)-C*Time >= 50.0) then
        u(i) = 100.0 * sin(PI * ((x(i)-C*Time) - 50.0) / 60.0)       
    else
        u(i)=0.d0
    end if
end do

end Subroutine Exact_solution
!----------------Implicit Euler--------------------------------
subroutine implicit_euler()
use variables
implicit none
!
Do i=1,ni
Residual = 0d0
!-------------------implimentation Boubdary Condition-----------
call Boundary_conditions()
!---------------------------------------------------------------
! Creating the 3-diagonal Matrix
AA(:) = -.5 * CFL
DD(:) = -1
BB(:) = .5 * CFL

Do j = 1, ni
    CC(j) = -u(j)
Enddo
! Call the Thomas algorithm for solving the linear system of algebraic equations
call SY(1, ni, BB, DD, AA, CC)
unew(1:ni) = CC(1:ni)
Residual = Residual + sqrt(abs(unew(i) - u(i)))
u(i)     = unew(i)
end do
!    
end subroutine implicit_euler 
!--------------------------------------------------------------   
end program first_order_wave
