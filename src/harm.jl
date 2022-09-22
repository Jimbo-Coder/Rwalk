using Plots


eme = 1
scale = 10^14
w0 = 2*pi*10^15
Γ = 10^9
range = 15


function fexact(w)
   b = eme/(w0^2 - w^2 - 2*im*w*Γ)
   return(b)
end

function fapprox(w)
   c = eme/(2*w*(w0-w) - 2*im*w*Γ)
   return(c)
end
function mainosc()

   xr = (w0 - range*Γ):(2*range*Γ/200):(w0 + range*Γ)
   f1 = fexact.(xr)
   f2 = fapprox.(xr)
   return(xr,f1,f2)
end

function plot()

   a,b,c = mainosc()

   re1 = real(b);im1 = imag(b);
   re2 = real(c); im2 = imag(c);

   l = @layout [a b]
   p = plot( layout = l)

   plot!(p[1], a, real(b)*scale,label="real Exact")
   plot!(p[1],a, real(c)*scale, label = "real Approx")

   plot!(p[2],a, imag(b)*scale,label="imags Exact")
   plot!(p[2],a, imag(c)*scale,label = "imags Approx")



   plot(p);gui()


end

function plotresid()
   a,b,c = mainosc()

   re1 = real(b);im1 = imag(b);
   re2 = real(c); im2 = imag(c);

   reresid = real(b) - real(c)
   imresid = imag(b) - imag(c)

   l = @layout [a b]
   g = plot( layout = l)

   plot!(g[1],a, reresid*scale^2, label = "Realresid")
   plot!(g[2],a, imresid*scale^2, label = "Imresid")

   plot(g);gui()

end




