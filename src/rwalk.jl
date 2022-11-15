module rwalk
using Distributed, ProgressMeter, CUDA, StatsBase, LsqFit

include("harm.jl")
include("hw4.jl")
include("hw5320.jl")
include("hw6320.jl")

greet() = print("Hello World!")


cutoff = 10000

function walk1d(N)
   steps = zeros(N)
   walkers = zeros(N)
   p = Progress(N, 1, "1D")
   single = [0]
   
   Threads.@threads for i in 1:N
      if steps[i] == 0
         t1 = rand(Float64)
         if t1 < 0.5
            walkers[i] = walkers[i] + 1
         end
         if t1 > 0.5
            walkers[i] = walkers[i] - 1
         end
         steps[i] = steps[i] + 1

         if i == 1
            push!(single,walkers[1])
         end

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
            
            if i == 1
               push!(single,walkers[1])
            end
         end
         
         update!(p,i)
      end
   end


   return (steps, walkers, single)
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
   single = []; push!(single, [0,0]);
   Threads.@threads for i in 1:N
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
      if i == 1
         push!(single,[walkers[1,1],walkers[1,2]])
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
         if i == 1
            push!(single,[walkers[1,1],walkers[1,2]])
         end
      end
      update!(p2,i)
   end
   return (steps, walkers, single)

end

function walk3d(N)
   steps = zeros(N)
   walkers = zeros(N, 3)
   p3 = Progress(N, 1, "3D")
   single = []; push!(single, [0,0,0]);
   Threads.@threads for i in 1:N
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

      if i == 1
         push!(single,[walkers[1],walkers[2],walkers[3]])
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

         if i == 1
            push!(single,[walkers[1],walkers[2],walkers[3]])
         end
      end
      update!(p3,i)
   end
   return (steps, walkers, single)

end

function results()
   N = Int(1e6)
   b1, c1,d1 = rwalk.walk1d(N)
   b2, c2, d2 = rwalk.walk2d(N)
   b3, c3, d3 = rwalk.walk3d(N)

   counter1 = 0;counter2=0;counter3=0;
   t1=[];t2=[];t3=[]
   for i in 1:N
      if b1[i] > cutoff - 100
         counter1 = counter1 + 1
      else
         push!(t1, b1[i])
      end
      if b2[i] > cutoff - 100
         counter2 = counter2 + 1
      else
         push!(t2, b2[i])
      end
      if b3[i] > cutoff - 100
         counter3 = counter3 + 1
      else
         push!(t3, b3[i])
      end
   end

   println(counter1, "\n",counter2, "\n",counter3 ,"\n")
   # print(d1,d2,d3)
   
   
   d2 =mapreduce(permutedims, vcat, d2)
   d3 =mapreduce(permutedims, vcat, d3)

   w1 = plot(d1,xlims = (-5,5))
   w2= plot(d2[:,1], d2[:,2],xlims = (-5,5),ylims = (-5,5))
   w3= plot(d3[:,1], d3[:,2],d3[:,3],xlims = (-5,5),ylims = (-5,5),zlims = (-5,5))

   g1 = fit(Histogram, Float64.(t1),nbins = 5000)
   g2 = fit(Histogram,Float64.(t2),nbins = 5000)
   g3 = fit(Histogram,Float64.(t3),nbins = 5000) #Trimmed Histogram, removed Cutoff bins

   # g1 = fit(Histogram, Float64.(b1),nbins = 1000)
   # g2 = fit(Histogram,Float64.(b2),nbins = 1000)
   # g3 = fit(Histogram,Float64.(b3),nbins = 1000)  #Untrimmed, maintain cutoff bins

   w4 = plot(g1, xlims = (0,60),label = "1D",dpi = 400,title = "UnBiased Distributions")
   w5 = plot!(g2, xlims = (0,60),label = "2D", dpi = 400,seriesalpha = 0.7)
   w6 = plot!(g3, xlims = (0,60),label = "3D", dpi = 400, seriesalpha = 0.4)  #All 3 Histogram together
   plot(w4); gui()
   savefig("C:/Users/maxri/Desktop/Classes 4-1/phys426(therm.)/plots/123DUnBiased")

   norm1 = N-counter1; norm2 = N-counter2; norm3 = N-counter3;

   println(counter1/N, "\n",counter2/N, "\n",counter3/N ,"\n")

   y1 = g1.weights; y2 = g2.weights; y3 = g3.weights;

   # y1 = y1 ./norm1 ; y2 = y2 ./ norm2; y3 = y3 ./ norm3 #Normalize the Distributions

   p0 = [0.5,0.5];

   m(t, p) = p[1] * exp.(p[2] * t)

   xs = 1:2:80
   fit1 = curve_fit(m,xs, y1[1:40], p0)
   fit2 = curve_fit(m,xs, y2[1:40] , p0)
   fit3 = curve_fit(m,xs, y3[1:40], p0)

   p1 = plot(title = "Distributions",xlims = (0,100),ylims = (0,y1[1]))
   scatter!(xs, y1);
   scatter!(xs, y2);
   scatter!(xs, y3);
   plot!(xs, fit1.param[1] * exp.(fit1.param[2]* xs),label="1D Fit")
   plot!(xs, fit2.param[1] * exp.(fit2.param[2]* xs),label="2D Fit")
   plot!(xs, fit3.param[1] * exp.(fit3.param[2]* xs),label="3D Fit")

   plot(p1); #gui()

   return(fit1,fit2,fit3)

  
end


end # module rwalk
