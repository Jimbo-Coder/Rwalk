using Plots


function Pn(n)
   N = 16; p = 2/3;

   b = (factorial(N) / (factorial(n)*factorial(N-n)))* (p^n)*((1-p)^(N-N))

   return(b)

end

function lPn(x)
   a = 0; γ = 1;
   b = (1/π)*(γ/ (((x-a)^2) +γ^2))
   return(b)

end

function pPn(n)
   p = 0.01; N = 100; λ = p*N;
   b = λ^n *ℯ^(-λ)/(factorial(big(n)))
   return(b)
end

function p331()
   x = collect(1:16)
   pn = Pn.(x)

   p1 = plot(x,pn, xlabel = "n", ylabel ="Pn",title = "Binomial Distribution",st=:scatter,
   label="N=16,p=2/3", ylims = (0,750))
   gui();
   #savefig(p1, ".\\Desktop\\Classes 4-1\\phys426(therm.)\\Plots\\Binomialplot2")
end

function p343()
   x = -50:.01:50
   pn = lPn.(x)

   p1 = plot(x,pn, xlabel = "n", ylabel ="Pn",title = "Cauchy Distribution",
   label="a=0,γ=1")
   print(lPn(0))
end

function p347()
   x = collect(1:1:100)
   pn = pPn.(x)

   p1 = plot(x,pn, xlabel = "n", ylabel ="Pn",title = "Poisson Distribution",
   label="p=0.01;N=100",st=:scatter,markersize = 2,xlims = (0,50))
   #savefig(p1, ".\\Desktop\\Classes 4-1\\phys426(therm.)\\Plots\\PoissonPlot")
end