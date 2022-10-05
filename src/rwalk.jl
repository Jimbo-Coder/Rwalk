module rwalk
using Distributed, ProgressMeter, CUDA

include("harm.jl")
include("hw4.jl")
include("hw7320.jl")
greet() = print("Hello World!")


cutoff = 10000

function walk1d(N)
   steps = zeros(N)
   walkers = zeros(N)
   p = Progress(N, 1, "1D")
   for i in 1:N
      if steps[i] == 0
         t1 = rand(Float64)
         if t1 < 0.5
            walkers[i] = walkers[i] + 1
         end
         if t1 > 0.5
            walkers[i] = walkers[i] - 1
         end
         steps[i] = steps[i] + 1
         while walkers[i] != 0
            t1 = rand(Float64)
            if t1 < 0.5
               walkers[i] = walkers[i] + 1
            end
            if t1 > 0.5
               walkers[i] = walkers[i] - 1
            end
            if steps[i] > cutoff
               walkers[i] = 0
            end
            steps[i] = steps[i] + 1
            
         end
         
         update!(p,i)
      end
   end


   return (steps, walkers)
end

function walk1dgpu(N)
   steps = zeros(N)
   walkers = zeros(N)

   walkers = CuArray(walkers)
   steps = CuArray(steps)
   p = Progress(N, 1,"1D GPU")

   Threads.@threads for i in 1:N
      if steps[i] == 0
         t1 = rand(Float64)
         if t1 < 0.5
            @inbounds walkers[i] = walkers[i] + 1
         end
         if t1 > 0.5
            @inbounds walkers[i] = walkers[i] - 1
         end
         @inbounds steps[i] = steps[i] + 1
         while walkers[i] != 0
            t1 = rand(Float64)
            if t1 < 0.5
               @inbounds walkers[i] = walkers[i] + 1
            end
            if t1 > 0.5
               @inbounds walkers[i] = walkers[i] - 1
            end
            if steps[i] > cutoff
               @inbounds walkers[i] = 0
            end
            @inbounds steps[i] = steps[i] + 1
            
         end
         
         update!(p,i)
      end
   end


   return (steps, walkers)
end

function walk2d(N)
   steps = zeros(N)
   walkers = zeros(N, 2)
   p2 = Progress(N, 1, "2D")
   for i in 1:N
      t1 = rand(Float64)

      if 0< t1 < 0.25
         walkers[i, 1] = walkers[i, 1] + 1
      end
      if 0.25 < t1 < 0.50
         walkers[i, 1] = walkers[i, 1] - 1
      end

      if 0.50 < t1 < 0.75
         walkers[i, 2] = walkers[i, 2] + 1
      end
      if 0.75 < t1 <1.00
         walkers[i, 2] = walkers[i, 2] - 1
      end


      steps[i] = steps[i] + 1
      while walkers[i, 1] != 0 || walkers[i, 2] != 0
         t1 = rand(Float64)


         if 0< t1 < 0.25
            walkers[i, 1] = walkers[i, 1] + 1
         end
         if 0.25 < t1 < 0.50
            walkers[i, 1] = walkers[i, 1] - 1
         end
   
         if 0.50 < t1 < 0.75
            walkers[i, 2] = walkers[i, 2] + 1
         end
         if 0.75 < t1 <1.00
            walkers[i, 2] = walkers[i, 2] - 1
         end

         if steps[i] > cutoff
            walkers[i, 1] = 0
            walkers[i, 2] = 0
         end


         steps[i] = steps[i] + 1
      end
      update!(p2,i)
   end
   return (steps, walkers)

end

function walk3d(N)
   steps = zeros(N)
   walkers = zeros(N, 3)
   p3 = Progress(N, 1, "3D")
   for i in 1:N
      t1 = rand(Float64)
      

      if 0< t1 < 1/6
         walkers[i, 1] = walkers[i, 1] + 1
      end
      if 1/6 < t1 < 2/6
         walkers[i, 1] = walkers[i, 1] - 1
      end

      if 2/6 < t1 < 3/6
         walkers[i, 2] = walkers[i, 2] + 1
      end
      if 3/6 < t1 <4/6
         walkers[i, 2] = walkers[i, 2] - 1
      end

      if 4/6 < t1 < 5/6
         walkers[i, 3] = walkers[i, 3] + 1
      end
      if 5/6 < t1 <6/6
         walkers[i, 3] = walkers[i, 3] - 1
      end


      steps[i] = steps[i] + 1
      while walkers[i, 1] != 0 || walkers[i, 2] != 0 || walkers[i, 3] != 0
         t1 = rand(Float64)


         if 0< t1 < 1/6
            walkers[i, 1] = walkers[i, 1] + 1
         end
         if 1/6 < t1 < 2/6
            walkers[i, 1] = walkers[i, 1] - 1
         end
   
         if 2/6 < t1 < 3/6
            walkers[i, 2] = walkers[i, 2] + 1
         end
         if 3/6 < t1 <4/6
            walkers[i, 2] = walkers[i, 2] - 1
         end
   
         if 4/6 < t1 < 5/6
            walkers[i, 3] = walkers[i, 3] + 1
         end
         if 5/6 < t1 <6/6
            walkers[i, 3] = walkers[i, 3] - 1
         end

         if steps[i] > cutoff
            walkers[i, 1] = 0
            walkers[i, 2] = 0
            walkers[i, 3] = 0
         end


         steps[i] = steps[i] + 1
      end
      update!(p3,i)
   end
   return (steps, walkers)

end




end # module rwalk
