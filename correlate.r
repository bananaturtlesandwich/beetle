library(rstudioapi)
hold.times = read.csv(selectFile())
cor.test(hold.times$var, hold.times$hold.time)

# if variable is in seconds multiply by speed
hold.times$var = hold.times$var * 0.5

# enter name of the independent variable into the console
plot(hold.time~var, data=hold.times, xlab=readline(), ylab="hold time (seconds)")
