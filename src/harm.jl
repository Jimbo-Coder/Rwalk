
eme = 1
w0 = 2*pi*10^15
Γ = 10e9



function fexact(w)
   b = 1/(w0^2 - w^2 - 2*im*w*Γ)
   return(b)
end

function fapprox(w)
   c = 1/(2*w*(w0-w) - 2*im*w*Γ)
   return(c)
end
function main()

   xr = Int(w0 - 15*Γ):Int(30*Γ/200):Int(w0 + 15*Γ)
   f1 = fexact.(xr)
   f2 = fapprox.(xr)
   return(xr,f1,f2)
end

main()


export(fexact); export(fapprox);