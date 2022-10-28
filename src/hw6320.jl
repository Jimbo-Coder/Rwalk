using Symbolics, ForwardDiff, Plots

B = [1.03961212, 2.31792344e-1,1.01046945];
C = [6.00069867e-3,2.00179144e-2,1.03560653e2];

function n2(x)
   b = 1 + B[1]*(x^2)/(x^2 - C[1]) + B[2]*(x^2)/(x^2 - C[2]) + B[3]*(x^2)/(x^2 - C[3])

   return(b^0.5)

end

function dndx(x)

   b = ForwardDiff.derivative(n2,x)
   return(b)

end


function p31()
   c = 3e8;

   x=collect(0.2:0.001:1.2)
   n=[]
   for i in x
      push!(n, n2(i))

   end

   p1=plot(x,n,title = "Sellmeier",ylabel = "n",xlabel = "λ (Microns)",dpi=300,legend = false)


   vph = c ./n
   dn = []

   for i in x
      push!(dn, dndx(i))

   end
   
   vgr = vph ./ (1 .- (x ./ n2.(x)) .* dn)

   p2=plot(x,vph,title = "Phase & Group Velocity",ylabel = "Vₚₕₐₛₑ (m/s)",
      xlabel = "λ (Microns)",dpi=300,label= "Phase Velocity",legend=:bottomright)
   plot!(x,vgr,ylabel = "V (m/s)",xlabel = "λ (Microns)",dpi=300,label = "Group Velocity")
   plot(p2);gui()

   #hline!([c],line=:dashed)
   #gui()
   #savefig(p2, ".\\Desktop\\Classes 4-1\\phys320\\Plots\\Groupvelplot")



end

function p32()
   c = 3e8;

   x=collect(0.79:0.001:0.81)
   n=[]
   for i in x
      push!(n, n2(i))

   end

   p1=plot(x,n,title = "Sellmeier",ylabel = "n",xlabel = "λ (Microns)",dpi=300,legend = false)


   vph = c ./n
   dn = []

   for i in x
      push!(dn, dndx(i))

   end
   
   vgr = vph ./ (1 .- (x ./ n2.(x)) .* dn)
   print(findall(in(.795),x),findall(in(.805),x))
   print(vgr[6] - vgr[16])

   print(.1/(vgr[6] - vgr[16]))
   p2=plot(x .*(10^3),vph,title = "Phase & Group Velocity",ylabel = "Vₚₕₐₛₑ (m/s)",
      xlabel = "λ (nm)",dpi=300,label= "Phase Velocity",legend=:right)
   plot!(x .*(10^3),vgr,ylabel = "V (m/s)",xlabel = "λ (nm)",dpi=300,label = "Group Velocity")
   plot(p2);gui()

   #hline!([c],line=:dashed)
   #gui()
   #savefig(p2, ".\\Desktop\\Classes 4-1\\phys320\\Plots\\Groupvelplot2")



end