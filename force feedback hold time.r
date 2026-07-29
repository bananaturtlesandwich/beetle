library(rstudioapi)
folder = selectDirectory(caption="select the data folder")
data = list.files(path=folder)

library(hash)
table = hash()
# use if non-rough surface
table[["2"]] = 1.3
table[["4"]] = 1.8
# use if 0.5 um rough
table[["1"]] = 1.0
table[["2"]] = 1.2
table[["4"]] = 1.7
# both
table[["6"]] = 2.3
table[["8"]] = 3.0
table[["10"]] = 3.7
table[["12"]] = 4.8
table[["2"]] = 4.8

var = array(dim=length(data))
hold = array(dim=length(data))
for (j in 1:length(data)) {
  test = data[j]
  if (!startsWith(test, "2013")) {
    next
  }
  sp = strsplit(test, ' ')[[1]]
  prehold = sp[[length(sp)]]
  # remove .txt
  prehold = substring(prehold, 1, nchar(prehold) - 4)
  # remove N
  if (endsWith(prehold, 'N')) {
    prehold = substring(prehold, 1, nchar(prehold) - 1)
  }
  
  # for force feedback (since max value isn't start)
  time = 11.5 + table[[prehold]]
  print(prehold)
  
  t = read.csv(paste(folder, test, sep="/"), sep='\t', header=FALSE)
  names(t) = c("time", "", "", "", "displacement", "", "force", "", "", "")
  
  pos = 1
  max = 0
  for (i in 1:length(t$time)) {
    if (t$time[i] > time) {
      pos = i
      max = t$time[i]
      break
    }
  }
  
  end = t$time[length(t$time)]
  for (i in pos:length(t$force)) {
    if (t$force[i] < 150.0){
      end = t$time[i]
      break
    }
  }
  var[j] = prehold
  hold[j] = end - max
}

times = data.frame(var, hold)
write.csv(times, paste(folder, "hold times.csv", sep="/"))