hold.times = read.csv("adam/rough 0.5um/rough 0.5um preload force with constant displacement/hold times.csv")
cor.test(hold.times$var, hold.times$hold.time)
plot(hold.time~var, data=hold.times, xlab="preload force", ylab="hold time")
