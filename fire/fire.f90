program fire
!use IFPORT
   implicit none

   type obj
      integer :: x = 0, y = 0
   end type

   integer, parameter :: L1 = 500, w = 500

   type(obj), dimension(L1*L1) :: b
   integer, dimension(L1, L1) :: a = 0
   integer :: t, t_max
   integer :: a1, a2, m, n, i, j, q, k, r, ab, ac, po, L, pl
   real :: p, p_max, clock_start, clock_finish

   CALL RANDOM_SEED()

   open (10, file="pos.dat")
   do pl = 10, 500, 10
      t_max = 0
      p_max = 0.0
      L = pl
      p = 0.59
      call cpu_time(clock_start)
      do po = 1, 40
         p = p + 0.001
         k = int(p*L*L) + 1
         t = 0
         if (p > 0.5) then
            k = L*L - k
            ab = 0
            ac = 1
         else
            ab = 1
            ac = 0
         end if
         do r = 1, w
            n = 0
            a = ac
            do while (n < k + 1)
               a1 = int(rand()*L) + 1
               a2 = int(rand()*L) + 1
               if (a1 > L) a1 = L
               if (a2 > L) a2 = L
               if (a(a1, a2) .NE. ab) then
                  a(a1, a2) = ab
                  n = n + 1
               end if
            end do
            do
               a1 = int(rand()*L) + 1
               a2 = int(rand()*L) + 1
               if (a1 > L) a1 = L
               if (a2 > L) a2 = L
               if (a(a1, a2) .NE. 1) then
                  b(1)%x = a1
                  b(1)%y = a2
                  exit
               end if
            end do
            a(b(1)%x, b(1)%y) = -1
            m = 1
            n = 1
            q = 1
            do while (q .NE. 0)
               q = 0
               do j = m, n
                  if (b(j)%x < L) then
                     if (a(b(j)%x + 1, b(j)%y) == 1) then
                        a(b(j)%x + 1, b(j)%y) = -1
                        q = q + 1
                        b(n + q)%x = b(j)%x + 1
                        b(n + q)%y = b(j)%y
                     end if
                  end if
                  if (b(j)%x > 1) then
                     if (a(b(j)%x - 1, b(j)%y) == 1) then
                        a(b(j)%x - 1, b(j)%y) = -1
                        q = q + 1
                        b(n + q)%x = b(j)%x - 1
                        b(n + q)%y = b(j)%y
                     end if
                  end if
                  if (b(j)%y < L) then
                     if (a(b(j)%x, b(j)%y + 1) == 1) then
                        a(b(j)%x, b(j)%y + 1) = -1
                        q = q + 1
                        b(n + q)%x = b(j)%x
                        b(n + q)%y = b(j)%y + 1
                     end if
                  end if
                  if (b(j)%y > 1) then
                     if (a(b(j)%x, b(j)%y - 1) == 1) then
                        a(b(j)%x, b(j)%y - 1) = -1
                        q = q + 1
                        b(n + q)%x = b(j)%x
                        b(n + q)%y = b(j)%y - 1
                     end if
                  end if
               end do
               t = t + 1
               m = n + 1
               n = n + q
            end do ! end for
         end do !end for r
         if (t .GT. t_max) then
            t_max = t
            p_max = p
         end if
         !write(10,*) p, t/w
      end do !end for main loop in p
      call cpu_time(clock_finish)
      write (*, *) L, p_max, "CPU Time = ", (clock_finish - clock_start), " seconds"
      write (10, *) 1.0/(L*1.0), p_max
   end do !for main loop in L
   close (10)

end program fire
