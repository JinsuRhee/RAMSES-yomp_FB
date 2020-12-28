module stellar_commons
   integer(kind=4):: nt_SW, nz_SW  ! number of grids for time and metallicities
   real(kind=8),allocatable,dimension(:):: log_tSW ! log10 yr
   real(kind=8),allocatable,dimension(:):: log_zSW ! log10 z
   ! Notice that the values below should be normalised to 1Msun
   real(kind=8),allocatable,dimension(:,:):: log_cmSW  ! cumulative mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_ceSW  ! cumulative energy per 1Msun SSP     
   real(kind=8),allocatable,dimension(:,:):: log_cmzSW  ! cumulative metal mass fraction
   real(kind=8),allocatable:: log_cmSW_spec(:,:,:)      ! cumulative mass fraction for several species
end module

program rd_table
   use stellar_commons
   implicit none
   integer :: iz, ich, i
   real(kind=8),allocatable,dimension(:,:):: log_cmHSW  ! cumulative H mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_cmCSW  ! cumulative C mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_cmNSW  ! cumulative N mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_cmOSW  ! cumulative O mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_cmMgSW ! cumulative Mg mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_cmSiSW ! cumulative Si mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_cmSSW  ! cumulative S mass fraction 
   real(kind=8),allocatable,dimension(:,:):: log_cmFeSW ! cumulative Fe mass fraction
   real(kind=8),allocatable:: dum1d(:)
   logical::ok


   open(unit=10,file='/storage6/jinsu/var/YOMP_NewFB/s99org_kp_pagb.dat',status='old',form='unformatted')
   read(10) nt_SW, nz_SW

   allocate(log_tSW  (1:nt_SW))          ! log Gyr
   allocate(log_zSW  (1:nz_SW))          ! log absolute Z
   allocate(log_cmSW (1:nt_SW,1:nz_SW))  ! log cumulative mass fraction per Msun
   allocate(log_ceSW (1:nt_SW,1:nz_SW))  ! log cumulative energy in erg per Msun
   allocate(log_cmzSW(1:nt_SW,1:nz_SW))  ! log cumulative mass fraction per Msun

      allocate(log_cmHSW(1:nt_SW,1:nz_SW))
      allocate(log_cmCSW(1:nt_SW,1:nz_SW))
      allocate(log_cmNSW(1:nt_SW,1:nz_SW))
      allocate(log_cmOSW(1:nt_SW,1:nz_SW))
      allocate(log_cmMgSW(1:nt_SW,1:nz_SW))
      allocate(log_cmSiSW(1:nt_SW,1:nz_SW))
      allocate(log_cmSSW(1:nt_SW,1:nz_SW))
      allocate(log_cmFeSW(1:nt_SW,1:nz_SW))
     
   
   allocate(dum1d (1:nt_SW))
   read(10) dum1d
   log_tSW(:) = dum1d(:)
   deallocate(dum1d)
   allocate(dum1d (1:nz_SW))
   read(10) dum1d
   log_zSW(:) = dum1d(:)
   deallocate(dum1d)
   allocate(dum1d (1:nt_SW))
   !  cumulative stellar mass loss
   do iz=1,nz_SW
      read(10) dum1d
      log_cmSW(:,iz) = dum1d(:)
   enddo
   ! cumulative mechanical energy from winds
   do iz=1,nz_SW
      read(10) dum1d
      log_ceSW(:,iz) = dum1d(:)
   enddo
   ! cumulative metal mass from winds
   do iz=1,nz_SW
      read(10) dum1d
      log_cmzSW(:,iz) = dum1d(:)
   enddo

      ! cumulative H mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmHSW(:,iz) = dum1d(:)
      enddo
      ! cumulative He mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         !log_cmHeSW(:,iz) = dum1d(:)
      enddo
      ! cumulative C mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmCSW(:,iz) = dum1d(:)
      enddo
      ! cumulative N mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmNSW(:,iz) = dum1d(:)
      enddo
      ! cumulative O mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmOSW(:,iz) = dum1d(:)
      enddo
      ! cumulative Mg mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmMgSW(:,iz) = dum1d(:)
      enddo
      ! cumulative Si mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmSiSW(:,iz) = dum1d(:)
      enddo
      ! cumulative S mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmSSW(:,iz) = dum1d(:)
      enddo
      ! cumulative Fe mass from winds
      do iz=1,nz_SW
         read(10) dum1d
         log_cmFeSW(:,iz) = dum1d(:)
         PRINT *, log_cmFeSW(100+iz,iz)
      enddo

      
      deallocate(log_cmHSW,log_cmCSW,log_cmNSW,log_cmOSW)
      deallocate(log_cmMgSW,log_cmSiSW,log_cmSSW,log_cmFeSW)


   deallocate(dum1d)

end program
