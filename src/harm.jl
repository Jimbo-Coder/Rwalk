using Plots


eme = 1
scale = 10^14
w0 = 2*pi*10^15
Γ = 10^9
range = 15
Plots.scalefontsizes(.4)
function fexact(w)
   b = eme/(w0^2 - w^2 - 2*im*w*Γ)
   return(b)
end

function fapprox(w)
   c = eme/(2*w*(w0-w) - 2*im*w*Γ)
   return(c)
end
function main()

   xr = (w0 - range*Γ):(2*range*Γ/200):(w0 + range*Γ)
   f1 = fexact.(xr)
   f2 = fapprox.(xr)
   return(xr,f1,f2)
end

function plot1()
   #COPY PASTE INTO REPL, FUNCTION doesnt work for some reason thank you JULIA smiley
   #jk i used plot() too many places
   a,b,c = main()

   re1 = real(b);im1 = imag(b);
   re2 = real(c); im2 = imag(c);


   l = @layout [a b]
   p = plot( layout = l, title = "Amplitude Solution",xlabel = "w * 10^14", ylabel = "x * 10^-14")
   plot!(p[1],a/scale, real(b)*scale,label="real Exact")
   plot!(p[1],a/scale, real(c)*scale, label = "real Approx")
   vline!(p[1], [w0/scale], linewidth = .6, label = "")

   plot!(p[2],a/scale, imag(b)*scale,label="Imaginary Exact")
   plot!(p[2],a/scale, imag(c)*scale,label = "Imaginar Approx")
   vline!(p[2], [w0/scale], linewidth = .6,label = "")



   plot(p);gui()

   #savefig(p, ".\\Desktop\\Classes 4-1\\phys426(therm.)\\Plots\\OscPlot1")
end

function plotresid()
   #COPY PASTE INTO REPL, FUNCTION doesnt work for some reason thank you JULIA smiley
   #JK I used plot() in too many plafces
   a,b,c = main()

   l = @layout [a b]

   re1 = real(b);im1 = imag(b);
   re2 = real(c); im2 = imag(c);

   reresid = real(b) - real(c)
   imresid = imag(b) - imag(c)

   g = plot( layout = l, title = "Approximation Residuals",xlabel = "w * 10^14", ylabel = "x * 10^-14")

   plot!(g[1],a/scale, reresid*scale^2, label = "Real residual")
   plot!(g[2],a/scale, imresid*scale^2, label = "Imaginary residual")
   vline!(g[1], [w0/scale], linewidth = .6, label = "")

   plot!(g[1], xticks! = [w0/scale])
   plot!(g[2], xticks! = [w0/scale])
   vline!(g[2], [w0/scale], linewidth = .6, label = "")

   plot(g);gui()
   #savefig(g, ".\\Desktop\\Classes 4-1\\phys426(therm.)\\Plots\\OscPlot2")
end

b = 50; w = 3;

function fg(x)
   j = exp( -4* log(2)*(x - b)^2 * w^(-2))
   return(j)
end


function fl(x)
   h = (w/2)^2 / ((x-b)^2 + (w/2)^2)
   return(h)
end

function p2()
   xr = b-10*w: 20*w / 300: b+10*w
   gauss = fg.(xr)
   lorentz = fl.(xr)

   g = plot(layout = @layout[a b])
   plot!(g[1], xr, gauss, label = "Gaussian", title = "Real Distribution")
   plot!(g[1],xr, lorentz, label = "Lorentzian")

   logg = log.(gauss); logl = log.(lorentz);
   plot!(g[2], xr, logg, label = "Gaussian", title = "Log Distribution")
   plot!(g[2],xr, logl, label = "Lorentzian")
   #savefig(g, ".\\Desktop\\Classes 4-1\\phys426(therm.)\\Plots\\Distplot")

end
