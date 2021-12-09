!!++++++++++++++++++++++++++++++++++++++++++++++++++++
!> \brief Small program to generate histogram plots of the flow in the dome-universe.
!!
!! A fortran95 program
!! By Danny E.P. Vanpoucke
!! (c) 2020 https:\\dannyvanpoucke.be
!! Source distributed at https://github.com/DannyVanpoucke/NortonDomeExplorer
!<--------------------------------------------------
program histogramGenerator
  implicit none

  INTEGER, PARAMETER :: R_quad=SELECTED_REAL_KIND(33,4931)  !< 16 byte: quadruple precision
  INTEGER, PARAMETER :: I_long=SELECTED_INT_KIND(9)         !< 4 byte, Pascal long

  call RunGenerateHistogram()
  !call RunGenerateHistogramr0r1()

  contains

  subroutine RunGenerateHistogram()
  real(R_quad) :: r0min, r0max, v0min, v0max, dr, dv
  real(R_quad) :: r0, r1, r2, r3, r4, v0, v1, histwidth_r, histwidth_v
  integer(I_long) :: MaxIter, nr_r, nr_v, nhistr, nhistv, gridr, gridv, ir0, ir1, iv0, iv1
  integer :: ios, foo, nrr, nrv, cntv, cntr, nra
  real(R_quad) :: alpha, dt, dt2
  real(R_quad) :: alphaList(1:99)
  integer(I_long), allocatable :: hist_start(:,:), hist_arrive(:,:), hist_self(:,:)
  character(len=255) :: fmtstr, filename


  write(*,*) "Small program to create histogram-map of the N-dome"
  alpha=0.5_R_quad ! the power a in the manuscript, not the alpha from alpha-theory
  dt=0.01_R_quad
  MaxIter=1

  !write(*,*) "alpha       :"
  !read(*,*) alpha
  !alpha=alpha*1.0_R_quad
  write(*,*) "The power 'a' is taken for each value from 0.01 to 0.99."


  write(*,*) "R0 min and max :"
  read(*,*) r0min, r0max
  r0min=r0min*1.0_R_quad
  r0max=r0max*1.0_R_quad

  write(*,*) "V0 min and max   :"
  read(*,*) v0min, v0max
  v0min=v0min*1.0_R_quad
  v0max=v0max*1.0_R_quad

  write(*,*) "number of histogram bins r, v:"
  read(*,*) nhistr, nhistv
  write(*,*) "number of points per bin r, v:"
  read(*,*) gridr, gridv

  write(*,*) "Starting runs!"

  dt2=dt*dt
  !pre=(2.0_R_quad*(1.0_R_quad+alpha)/((1.0_R_quad-alpha)**2))**(1.0_R_quad/(1.0_R_quad-alpha))
  !pst=(0.5_R_quad*(1.0_R_quad-alpha))

  allocate(hist_start(1:nhistv,1:nhistr))
  allocate(hist_arrive(1:nhistv,1:nhistr))
  allocate(hist_self(1:nhistv,1:nhistr))
  hist_start=0
  hist_arrive=0
  hist_self=0


  dr=(r0max-r0min)/(nhistr*gridr)
  dv=(v0max-v0min)/(nhistv*gridv)
  histwidth_r=(r0max-r0min)/nhistr
  histwidth_v=(v0max-v0min)/nhistv

  do nra=1,99
    alphaList(nra)=nra*0.01_R_quad
  end do

  do nra=1, 99
      write(*,'(A,I3,A)') "Run ",nra," /99"
      write(filename,'(A,I0,A)') "vectorplot",nra,".dat"
      alpha=alphaList(nra)*1.0_R_quad

      foo=78
      open(UNIT=foo,FILE=filename,STATUS='REPLACE',ACCESS='SEQUENTIAL',ACTION='WRITE',IOSTAT=ios)

      cntv=int(gridv*0.5)
      do nr_v=0, nhistv*gridv
        v0=v0min+nr_v*dv+0.5_R_quad*dv
        cntv=mod(cntv+1,gridv)
        cntr=int(gridr*0.5)
        do nr_r=0, nhistr*gridr
            r0=r0min+nr_r*dr+0.5_R_quad*dr
            r1=v0*dt+r0
            !r2=-r0+2.0_R_quad*r1+dt2*(r1**alpha)
            r2=-r0+2.0_R_quad*r1+dt2*sign(1.0_R_quad,r1)*(abs(r1)**alpha)
            v1=(r2-r1)/dt
            !r3=-r1+2.0_R_quad*r2+dt2*sign(1.0_R_quad,r2)*(abs(r2)**alpha)
            !r4=-r2+2.0_R_quad*r3+dt2*sign(1.0_R_quad,r3)*(abs(r3)**alpha)
            !v1=(r4-r3)/dt
            !r1=r3

            if (cntv==0) then
                cntr=mod(cntr+1,gridr)
                if (cntr==0) then
                    write(foo,'(5(E12.6,X))') v0,r0,v1-v0,r1-r0,sqrt(((r1-r0)**2)+((v1-v0)**2))
                end if
            end if
    ! riter(nri)=-riter(nri-2)+2.0_R_quad*riter(nri-1)+sign(1.0_R_quad,riter(nri-1))*f1*(abs(riter(nri-1))**p1)

            !and now increment the histograms
            ir0=floor((r0-r0min)/histwidth_r)+1
            iv0=floor((v0-v0min)/histwidth_v)+1
            ir1=floor((r1-r0min)/histwidth_r)+1
            iv1=floor((v1-v0min)/histwidth_v)+1
            if (((ir0>0).and. (ir0<=nhistr)).and.((iv0>0).and. (iv0<=nhistv))) then !we are in the plot
                hist_start(iv0,ir0)=hist_start(iv0,ir0)+1
                if (((ir1>0).and. (ir1<=nhistr)).and.((iv1>0).and. (iv1<=nhistv))) then !we are in the plot
                    hist_arrive(iv1,ir1)=hist_arrive(iv1,ir1)+1
                    if ((ir0==ir1).and.(iv0==iv1)) then ! remains in box
                        hist_self(iv1,ir1)=hist_self(iv1,ir1)+1
                    end if
                end if
            end if
        end do
      end do
      close(foo)
  end do


  !and now we need to print the results
  foo=77
  open(UNIT=foo,FILE="results.csv",STATUS='REPLACE',ACCESS='SEQUENTIAL',ACTION='WRITE',IOSTAT=ios)
  write(fmtstr,'(A,I0,A)') '(',nhistr,'(I0,A))'
  write(foo,*)"Occupation of start-positions , , ,"
  do nrv=1, nhistv
    !write line per line
    write(foo,fmtstr) (hist_start(nrv,nrr),",",nrr=1,nhistr)
  end do
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)"Occupation of end-positions , , ,"
  do nrv=1, nhistv
    !write line per line
    write(foo,fmtstr) (hist_arrive(nrv,nrr),",",nrr=1,nhistr)
  end do
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)"Occupation of self-targeting , , ,"
  do nrv=1, nhistv
    !write line per line
    write(foo,fmtstr) (hist_self(nrv,nrr),",",nrr=1,nhistr)
  end do

  close(foo)
  deallocate(hist_start,hist_arrive,hist_self)

  write(*,*) "Done!"
  end subroutine RunGenerateHistogram




  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


  subroutine RunGenerateHistogramr0r1()
  real(R_quad) :: r0min, r0max, v0min, v0max, dr, dv
  real(R_quad) :: r0, r1, r2, v0, v1, histwidth_r, histwidth_v
  integer(I_long) :: MaxIter, nr_r, nr_v, nhistr, nhistv, gridr, gridv, ir0, ir1, iv0, iv1
  integer :: ios, foo, nrr, nrv
  real(R_quad) :: alpha, dt, dt2
  integer(I_long), allocatable :: hist_start(:,:), hist_arrive(:,:), hist_self(:,:)
  character(len=255) :: fmtstr


  write(*,*) "Small program to create histogram-map of the N-dome"
  alpha=0.5_R_quad
  dt=0.01_R_quad
  MaxIter=1

  write(*,*) "alpha       :"
  read(*,*) alpha
  alpha=alpha*1.0_R_quad

  write(*,*) "R0 min and max :"
  read(*,*) r0min, r0max
  r0min=r0min*1.0_R_quad
  r0max=r0max*1.0_R_quad

  write(*,*) "V0 min and max   :"
  read(*,*) v0min, v0max
  v0min=v0min*1.0_R_quad
  v0max=v0max*1.0_R_quad

  write(*,*) "number of histogram bins r, v:"
  read(*,*) nhistr, nhistv
  write(*,*) "number of points per bin r, v:"
  read(*,*) gridr, gridv

  write(*,*) "Starting runs!"

  dt2=dt*dt
  !pre=(2.0_R_quad*(1.0_R_quad+alpha)/((1.0_R_quad-alpha)**2))**(1.0_R_quad/(1.0_R_quad-alpha))
  !pst=(0.5_R_quad*(1.0_R_quad-alpha))

  allocate(hist_start(1:nhistv,1:nhistr))
  allocate(hist_arrive(1:nhistv,1:nhistr))
  allocate(hist_self(1:nhistv,1:nhistr))
  hist_start=0
  hist_arrive=0
  hist_self=0


  dr=(r0max-r0min)/(nhistr*gridr+1)
  dv=(v0max-v0min)/(nhistv*gridv+1)
  histwidth_r=(r0max-r0min)/nhistr
  histwidth_v=(v0max-v0min)/nhistv

  do nr_v=0, nhistv*gridv
    v0=v0min+nr_v*dv
    do nr_r=0, nhistr*gridr
        r0=r0min+nr_r*dr
        r1=v0
        !r2=-r0+2.0_R_quad*r1+dt2*(r1**alpha)
        r2=-r0+2.0_R_quad*r1+dt2*sign(1.0_R_quad,r1)*(abs(r1)**alpha)
        v1=r2*0.5
        r1=r1*0.5
! riter(nri)=-riter(nri-2)+2.0_R_quad*riter(nri-1)+sign(1.0_R_quad,riter(nri-1))*f1*(abs(riter(nri-1))**p1)

        !and now increment the histograms
        ir0=floor((r0-r0min)/histwidth_r)+1
        iv0=floor((v0-v0min)/histwidth_v)+1
        ir1=floor((r1-r0min)/histwidth_r)+1
        iv1=floor((v1-v0min)/histwidth_v)+1
        if (((ir0>0).and. (ir0<=nhistr)).and.((iv0>0).and. (iv0<=nhistv))) then !we are in the plot
            hist_start(iv0,ir0)=hist_start(iv0,ir0)+1
            if (((ir1>0).and. (ir1<=nhistr)).and.((iv1>0).and. (iv1<=nhistv))) then !we are in the plot
                hist_arrive(iv1,ir1)=hist_arrive(iv1,ir1)+1
                if ((ir0==ir1).and.(iv0==iv1)) then ! remains in box
                    hist_self(iv1,ir1)=hist_self(iv1,ir1)+1
                end if
            end if
        end if
    end do
  end do

  !and now we need to print the results
  foo=77
  open(UNIT=foo,FILE="results_r0r1.csv",STATUS='REPLACE',ACCESS='SEQUENTIAL',ACTION='WRITE',IOSTAT=ios)
  write(fmtstr,'(A,I0,A)') '(',nhistr,'(I0,A))'
  write(foo,*)"Occupation of start-positions , , ,"
  do nrv=1, nhistv
    !write line per line
    write(foo,fmtstr) (hist_start(nrv,nrr),",",nrr=1,nhistr)
  end do
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)"Occupation of end-positions , , ,"
  do nrv=1, nhistv
    !write line per line
    write(foo,fmtstr) (hist_arrive(nrv,nrr),",",nrr=1,nhistr)
  end do
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)" , , ,"
  write(foo,*)"Occupation of self-targeting , , ,"
  do nrv=1, nhistv
    !write line per line
    write(foo,fmtstr) (hist_self(nrv,nrr),",",nrr=1,nhistr)
  end do

  close(foo)
  deallocate(hist_start,hist_arrive,hist_self)

  write(*,*) "Done!"
  end subroutine RunGenerateHistogramr0r1


end program histogramGenerator
