hold.times = read.csv("adam/force feedback 2-12/hold times.csv")
cor.test(hold.times$var, hold.times$hold.time)
plot(hold.time~var, data=hold.times, xlab="variable", ylab="hold time")
