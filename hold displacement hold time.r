library(rstudioapi)
folder = selectDirectory()
data = list.files(path=folder)

for (test in data) {
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
  
  time = 11.0 + as.numeric(prehold)
  
  t = read.csv(paste(folder, test, sep="/"), sep='\t', header=FALSE)
  names(t) = c("time", "", "", "", "displacement", "", "force", "", "", "")
  
  pos = 0
  max = 0
  for (i in 1:length(t)) {
    if (t$time[i] > time) {
      pos = i
      max = t$time[i]
      break
    }
  }
  end = t$time[length(t)]
  for (i in pos:length(t)) {
    if (t$force[i] < 150.0){
      end = t$time[i]
    }
  }
  t$hold = end - max
}
