module rwalk
using Distributed, ProgressMeter, CUDA, StatsBase, LsqFit

include("harm.jl")
include("hw4.jl")
include("hw5320.jl")
include("hw6320.jl") #Misc Homeworks I used this file for, ignore 

greet() = print("Hello World!") #Hello!


cutoff = 10000 #Cutoff for walkers that don't return

#Walk1D has documentation Only, as well as Results
function walk1d(N,bia)
   steps = zeros(N) #Array of interest, number of steps for each walker
   walkers = zeros(N) #Random walkers, start at origin
   p = Progress(N, 1, "1D") #Progress Meter
   single = [0] #Individual walker's position
   
   Threads.@threads for i in 1:N
      if steps[i] == 0
         t1 = rand(Float64) #random number for Walker

         if t1 < bia[1]
            walkers[i] = walkers[i] + 1 #step right if <p
         end
         if t1 > bia[1]
            walkers[i] = walkers[i] - 1 #step left if >p
         end

         steps[i] = steps[i] + 1 #increment steps

         if i == 1
            push!(single,walkers[1]) #Individual walker Position
         end

         while walkers[i] != 0 #While walker not at origin, continue
            t1 = rand(Float64)
            if t1 < bia[1]
               walkers[i] = walkers[i] + 1 #step right if <p
            end
            if t1 > bia[1]
               walkers[i] = walkers[i] - 1 #step left if >p
            end
            if steps[i] > cutoff
               walkers[i] = 0     #Stop process if walker reaches the cutoff point
            end
            steps[i] = steps[i] + 1 #Increment amount of steps, the array of interest
            
            if i == 1
               push!(single,walkers[1]) #Record indiv. walker position, just 1. Not used.
            end
         end
         
         update!(p,i) #update Progress meter
      end
   end


   return (steps, walkers, single) #Return step array, walkers(0), and a single walkers path
end


#Failed, don't use
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

#No documentation
function walk2d(N,bia)
   steps = zeros(N)
   walkers = zeros(N, 2)
   p2 = Progress(N, 1, "2D")
   single = []; push!(single, [0,0]);
   Threads.@threads for i in 1:N
      t1 = rand(Float64)

      if 0< t1 < bia[1]
         walkers[i, 1] = walkers[i, 1] + 1
      end
      if bia[1] < t1 < bia[2]
         walkers[i, 1] = walkers[i, 1] - 1
      end

      if bia[2] < t1 < bia[3]
         walkers[i, 2] = walkers[i, 2] + 1
      end
      if bia[3]< t1 <1.00
         walkers[i, 2] = walkers[i, 2] - 1
      end
      if i == 1
         push!(single,[walkers[1,1],walkers[1,2]])
      end

      steps[i] = steps[i] + 1
      while walkers[i, 1] != 0 || walkers[i, 2] != 0
         t1 = rand(Float64)


         if 0< t1 < bia[1]
            walkers[i, 1] = walkers[i, 1] + 1
         end
         if bia[1] < t1 < bia[2]
            walkers[i, 1] = walkers[i, 1] - 1
         end
   
         if bia[2] < t1 < bia[3]
            walkers[i, 2] = walkers[i, 2] + 1
         end
         if bia[3] < t1 <1.00
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

#No Documentation
function walk3d(N, bia)
   steps = zeros(N)
   walkers = zeros(N, 3)
   p3 = Progress(N, 1, "3D")
   single = []; push!(single, [0,0,0]);
   Threads.@threads for i in 1:N
      t1 = rand(Float64)
      

      if 0< t1 < bia[1]
         walkers[i, 1] = walkers[i, 1] + 1
      end
      if bia[1] < t1 < bia[2]
         walkers[i, 1] = walkers[i, 1] - 1
      end

      if bia[2] < t1 < bia[3]
         walkers[i, 2] = walkers[i, 2] + 1
      end
      if bia[3] < t1 < bia[4]
         walkers[i, 2] = walkers[i, 2] - 1
      end

      if bia[4] < t1 < bia[5]
         walkers[i, 3] = walkers[i, 3] + 1
      end
      if bia[5] < t1 <6/6
         walkers[i, 3] = walkers[i, 3] - 1
      end

      if i == 1
         push!(single,[walkers[1],walkers[2],walkers[3]])
      end
      steps[i] = steps[i] + 1
      while walkers[i, 1] != 0 || walkers[i, 2] != 0 || walkers[i, 3] != 0
         t1 = rand(Float64)


         if 0< t1 < bia[1]
            walkers[i, 1] = walkers[i, 1] + 1
         end
         if bia[1] < t1 < bia[2]
            walkers[i, 1] = walkers[i, 1] - 1
         end
   
         if bia[2] < t1 < bia[3]
            walkers[i, 2] = walkers[i, 2] + 1
         end
         if bia[3] < t1 < bia[4]
            walkers[i, 2] = walkers[i, 2] - 1
         end
   
         if bia[4] < t1 < bia[5]
            walkers[i, 3] = walkers[i, 3] + 1
         end
         if bia[5] < t1 <6/6
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

#Documentation
function results()
   N = Int(1e4)
   b1, c1,d1 = rwalk.walk1d(N, [0.5])
   b2, c2, d2 = rwalk.walk2d(N,[0.25,0.5,0.75])
   b3, c3, d3 = rwalk.walk3d(N, [1/6,2/6,3/6,4/6,5/6]) #Unbiased Calls

   m1, n1,o1 = rwalk.walk1d(N, [1/3])           #1D Biased Calls 
   m11, n11,o11 = rwalk.walk1d(N, [0.8])

   m2, n2,o2 = rwalk.walk2d(N, [0.2,0.4,0.6])           #2D Biased Calls 
   m21, n21,o21 = rwalk.walk2d(N, [0.1,0.2,0.3])         #Heavily Biased

   m3, n3,o3 = rwalk.walk3d(N, [0.1,0.2,0.3,0.6,0.8])           #3D Biased Calls 
   m31, n31,o31 = rwalk.walk3d(N, [0.1,0.15,0.2,0.3,0.9])      #Heavily Biased

   counter1 = 0;counter2=0;counter3=0; #Unbiased Counter, number of walkers that did not return

   counter11 = 0;counter12 = 0;
   counter21 = 0;counter22 = 0; #Biased Counters, number of walkers that did not return
   counter31 = 0;counter32 = 0;

   t1=[];t2=[];t3=[] #Trimmed array
   for i in 1:N  #This loop kind of long, it calculates how many walkers reached the cutoff point,
      if b1[i] > cutoff - 100    #or did not converge, as well as creates the trimmed array.
         counter1 = counter1 + 1   
      else
         push!(t1, b1[i])  #trimmed array
      end
      if m1[i]> cutoff - 100 #Count number of walkers that did not return
         counter11 = counter11 +1
      end
      if m11[i]> cutoff - 100
         counter12 = counter12 +1
      end
      if m2[i]> cutoff - 100
         counter21 = counter21 +1
      end
      if m21[i]> cutoff - 100
         counter22 = counter22 +1
      end
      if m3[i]> cutoff - 100
         counter31 = counter31 +1
      end
      if m31[i]> cutoff - 100
         counter32 = counter32 +1
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

   println(counter1, "\n",counter2, "\n",counter3 ,"\n") #Print number of walkers that did not return, in each dimension
   # print(d1,d2,d3)
   
   
   d2 =mapreduce(permutedims, vcat, d2)
   d3 =mapreduce(permutedims, vcat, d3) #Not used/important


   norm1 = N-counter1; norm2 = N-counter2; norm3 = N-counter3; #normalization of each distribution, Number of converged walkers

   norm11 = N - counter11; norm12 = N - counter12; #Normaliziation of the biased distributions
   norm21 = N - counter21; norm22 = N - counter22; #2D biased
   norm31 = N - counter31; norm32 = N - counter32; #3D biased

   
   
   

   # w1 = plot(d1,xlims = (-5,5),xlabel = "Steps") #Indvidual Walker Plots
   # w2= plot(d2[:,1], d2[:,2],xlims = (-5,5),ylims = (-5,5),xlabel = "Steps")
   # w3= plot(d3[:,1], d3[:,2],d3[:,3],xlims = (-5,5),ylims = (-5,5),zlims = (-5,5),xlabel = "Steps")

   g1 = fit(Histogram, Float64.(t1),nbins = 5000) #fit trimmed 1D Histogram
   g2 = fit(Histogram,Float64.(t2),nbins = 5000)  #fit trimmed 2D
   g3 = fit(Histogram,Float64.(t3),nbins = 5000) #Trimmed 3D Histogram, removed Cutoff bins
  
   

   
   #untrimmed histogram of all distributions together
   # g1 = fit(Histogram, Float64.(b1),nbins = 1000)
   # g2 = fit(Histogram,Float64.(b2),nbins = 1000)
   # g3 = fit(Histogram,Float64.(b3),nbins = 1000)  #Untrimmed, maintain cutoff bins
   # plot(g1,g2,g3); gui()

   

   g11 = fit(Histogram, Float64.(m1),nbins = 5000);
   g12 = fit(Histogram, Float64.(m11),nbins = 5000); #1D Biased histogram

   g21 = fit(Histogram, Float64.(m2),nbins = 5000);
   g22 = fit(Histogram, Float64.(m21),nbins = 5000)  #2D Biased Histogram

   g31 = fit(Histogram, Float64.(m3),nbins = 5000);
   g32 = fit(Histogram, Float64.(m31),nbins = 5000)  #3D Biased Histogram

   y1 = g1.weights; y2 = g2.weights; y3 = g3.weights; #Grab weights of histogram, unbiased

   y11 = g11.weights; y12 = g12.weights; 
   y21 = g21.weights; y22 = g22.weights; #Grab weights of histogram, biased
   y31 = g11.weights; y32 = g32.weights; 

   y1 = y1 ./norm1 ; y2 = y2 ./ norm2; y3 = y3 ./ norm3 #Normalize the Distributions, unbiased

   y11 = y11 ./norm11 ; y12 = y12 ./norm12; #Normalize the Distributions, Biased
   y21 = y21 ./norm21 ; y22 = y22 ./norm22;
   y31 = y31 ./norm31 ; y32 = y32 ./norm32;
   
   println("1D no return ",counter1/N, "\n","2D no return ",counter2/N, "\n","3D no return ",counter3/N ,"\n") #Unbiased results/percentages

   println("1D Bias No return ","\n",counter11/N, "\n", counter12/N, "\n") #1D Biased Results/Percentages

   println("2D Bias No return ","\n",counter21/N, "\n", counter22/N, "\n") #2D Biased Results/Percentages

   println("3D Bias No return ","\n",counter31/N, "\n", counter32/N, "\n") #1D Biased Results/Percentages

  
   
   w4 = plot(g1, xlims = (0,60),label = "1D",dpi = 400,title = "Unbiased Distributions", xlabel = "Steps")
   plot!(g2, xlims = (0,60),label = "2D", dpi = 400,seriesalpha = 0.7)
   plot!(g3, xlims = (0,60),label = "3D", dpi = 400, seriesalpha = 0.4)  #All 3 Unbiased Histogram together
   

 
   
   # # 1D Biased & Unbiased Histogram

   # w5 = plot(g1, xlims = (0,60),label = "1D unbiased",dpi = 400,title = "1D Biased and Unbiased", #1D Plots
   # seriesalpha = 0.5,legendrank=2, xlabel = "Steps")
   # plot!(g11, xlims = (0,60),label = "1D Biased",dpi = 400,seriesalpha=0.4,legendrank=1)
   # plot!(g12, xlims = (0,60),label = "1D Heavily Biased",dpi = 400,seriesalpha=0.3,legendrank=3)

   # plot(w4); gui()

   # # 2D Biased & Unbiased Histogram

   # w5 = plot(g2, xlims = (0,40),label = "2D unbiased",dpi = 400,title = "2D Biased and Unbiased", #2D Plots
   # seriesalpha = 0.5,legendrank=2, xlabel = "Steps")
   # plot!(g21, xlims = (0,40),label = "2D Biased",dpi = 400,seriesalpha=0.4,legendrank=1)
   # plot!(g22, xlims = (0,40),label = "2D Heavily Biased",dpi = 400,seriesalpha=0.3,legendrank=3)

   # # 3D Biased & Unbiased Histogram

   # w6 = plot(g3, xlims = (0,20),label = "3D unbiased",dpi = 400,title = "3D Biased and Unbiased", #3D Plots
   # seriesalpha = 0.5,legendrank=2, xlabel = "Steps")
   # plot!(g31, xlims = (0,20),label = "3D Biased",dpi = 400,seriesalpha=0.4,legendrank=1)
   # plot!(g32, xlims = (0,20),label = "3D Heavily Biased",dpi = 400,seriesalpha=0.3,legendrank=3)

   plot(w4); gui()

   

   


   p0 = [5000.,0.5]; #Intial Values of fit

   #models to fit to distributions
   # m(t, p) = p[1] * exp.(p[2] * (t))  #Exponential FAILED
   m(t, p) = p[1] .* t.^(p[2])     # Power law

   xs = 1:2:20; xr = 1:.1:40; 
   #Fit power law to both biased & Unbiased distributions
   fit1 = curve_fit(m,xs, y1[1:10], p0); fit11 = curve_fit(m,xs, y11[1:10], p0); fit12 = curve_fit(m,xs, y12[1:10], p0)
   fit2 = curve_fit(m,xs, y2[1:10] , p0); fit21 = curve_fit(m,xs, y21[1:10], p0); fit22 = curve_fit(m,xs, y22[1:10], p0)
   fit3 = curve_fit(m,xs, y3[1:10], p0); fit31 = curve_fit(m,xs, y31[1:10], p0); fit32 = curve_fit(m,xs, y32[1:10], p0)

   # # Normalized 1D Bias & Unbiased Distributions

   # p1 = plot(title = "Normalized1D Distributions",xlims = (0,10),ylims = (0,1),xlabel = "Steps")
   # scatter!(xs, y1, c= :red, label = "");
   # scatter!(xs, y11,c=:blue,label = "");
   # scatter!(xs, y12,c=:green,label = "");
   # plot!(xr, m(xr, fit1.param),label="Unbiased Fit",c=:red)
   # plot!(xr, m(xr, fit11.param),label="Biased Fit", c=:blue)
   # plot!(xr, m(xr, fit12.param),label="Heavily Biased Fit", c=:green) #1D Distributions

   # # Normalized All Dimension Distributions

   # p2 = plot(title = "Normalized Distributions",xlims = (0,10),ylims = (0,y1[1]*1.05),xlabel = "Steps")
   # scatter!(xs, y1, c= :red, label = "");
   # scatter!(xs, y2,c=:blue,label = "");
   # scatter!(xs, y3,c=:green,label = "");
   # plot!(xr, m(xr, fit1.param),label="1D Fit",c=:red)
   # plot!(xr, m(xr, fit2.param),label="2D Fit", c=:blue)
   # plot!(xr, m(xr, fit3.param),label="3D Fit", c=:green) #1D Distributions


   # # Normalized 2D Bias & Unbiased Distributions

   # p3 = plot(title = "2D Normalized Distributions",xlims = (0,10),ylims = (0,1),xlabel = "Steps")
   # scatter!(xs, y2, c= :red, label = "");
   # scatter!(xs, y21,c=:blue,label = "");
   # scatter!(xs, y22,c=:green,label = "");
   # plot!(xr, m(xr, fit2.param),label="Unbiased Fit",c=:red)
   # plot!(xr, m(xr, fit21.param),label="Biased Fit", c=:blue)
   # plot!(xr, m(xr, fit22.param),label="Heavily Biased Fit", c=:green) #2D Distributions


   # # Normalized 3D Bias & Unbiased Distributions

   # p6 = plot(title = "3D Normalized Distributions",xlims = (0,10),ylims = (0,2),xlabel = "Steps")
   # scatter!(xs, y3, c= :red, label = "");
   # scatter!(xs, y31,c=:blue,label = "");
   # scatter!(xs, y32,c=:green,label = "");
   # plot!(xr, m(xr, fit3.param),label="Unbiased Fit",c=:red)
   # plot!(xr, m(xr, fit31.param),label="Biased Fit", c=:blue)
   # plot!(xr, m(xr, fit32.param),label="Heavily Biased Fit", c=:green) #3D Distributions

   
   
   # savefig(p6,"C:/Users/maxri/Desktop/Classes 4-1/phys426(therm.)/plots/3d Normed.png")

   return(fit1,fit2,fit3,fit2, fit21,fit22,fit3,fit31, fit32) #return fits, 9 total. 3 dimensions * 3 cases.

  
end


end # module rwalk
