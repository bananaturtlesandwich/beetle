library(rstudioapi)
hold.times = read.csv(selectFile())
# if variable is in seconds multiply by speed
# hold.times$var = hold.times$var * 0.5

cor.test(hold.times$var, hold.times$hold)

print("enter name of the independent variable into the console")
plot(hold~var, data=hold.times, xlab=readline(), ylab="hold time (seconds)")
