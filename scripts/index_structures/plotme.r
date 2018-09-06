
args = commandArgs(trailingOnly=TRUE)

if (length(args) != 3) {
  print(length(args))
  print(args)
  stop("need 3 args: values for log, width, height", call.=FALSE)
}

logv=args[1]
width=args[2]
height=args[3]

logarg=""
if (logv != "none") {
  logarg=paste(", log=\"", logv, "\"", sep="")
}
# print(logarg)

# L	wa-I	wa-C	sa	ca	Nruns	ph	pm	rs	rn

cols=c("wa.I", "wa.C", "sa", "ca", "Nruns", "ph", "pm", "rs", "rn")
cnames=c("write-amp(io)", "write-amp(cpu)", "space-amp", "cache-amp", "Nruns", "point-hit(cpu)", "point-miss(cpu)", "range-seek(cpu)", "range-next(cpu)")

df = read.table('o1', header=TRUE, stringsAsFactors=FALSE)
df$C <- "black"
df$C[df$F == "L"] <- "black"
df$C[df$F == "LN"] <- "blue"
df$C[df$F == "T"] <- "grey"
df$C[df$F == "TL"] <- "red"
df$C[df$F == "TLN"] <- "orange"

attach(df)

for (x in 1:length(cols)) {
  c <- cols[x]
  cn <- cnames[x]

  e <- paste("png(\"", c, "-x.png\", width=", width, ", height=", height, ")", sep="")
  eval(parse(text=e))
  par(mfrow=c(6,3), pty='s')
  for (y in 1:length(cols)) {
    if (y != x) {
      # plot(time, eval(parse(text=i)))
      e <- paste("plot(x=", c, ", y=", cols[y], logarg, ", cex.lab=1.5, xlab=\"", cn, "\", ylab=\"", cnames[y], "\", col=C)", sep="")
      # print(e)
      eval(parse(text=e))
      # e <- paste("text(x=", c, ", y=", cols[y], ", label=L, cex=0.5, adj=c(0, -1))", sep="")
      # eval(parse(text=e))
    }
  }
  plot(x=1, y=0)

  #e <- paste("png(\"", c, "-y.png\", width=1200, height=1200)", sep="")
  #eval(parse(text=e))
  #par(mfrow=c(3,3), pty='s')
  for (y in 1:length(cols)) {
    if (y != x) {
      # plot(time, eval(parse(text=i)))
      e <- paste("plot(y=", c, ", x=", cols[y], logarg, ", cex.lab=1.5, ylab=\"", cn, "\", xlab=\"", cnames[y], "\", col=C)", sep="")
      # print(e)
      eval(parse(text=e))
    }
  }
  plot(x=1, y=0)
  dev.off() 
}

