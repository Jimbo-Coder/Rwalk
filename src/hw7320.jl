using Plots, FFTW

function dirac()
   t = collect(-500:0.01:500)
   summer = zeros(length(t))
   for i in 1:150
      b = sin.(30 * rand() * t)
      #b = sin.(i/30*t)
      summer = summer + b
   end


   p1 = plot(t, summer, title="Amplitude", xlabel="t")
   p2 = plot(t, summer .^ 2, title="Power", xlabel="t")
   p3 = plot(p1, p2, layout=2, dpi=300)
   plot(p3)
   gui()
   #savefig(p3, ".\\Desktop\\Classes 4-1\\phys320\\Plots\\PulsePlot")
   print(findmax(summer), findmax(summer .^ 2))


   ft = fft(summer)
   ftfreq = fftfreq(length(summer), 1 / 0.01)

   p4 = plot(ftfreq, real(ft), xlabel="Freq(Hz)", ylabel="Amplitude", dpi=300)
   gui()
   #savefig(p4, ".\\Desktop\\Classes 4-1\\phys320\\Plots\\PulsePlotfft")
end