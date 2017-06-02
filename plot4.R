rm(list=ls())

###checking filezise (in MB)
checksize<-file.size("household_power_consumption.txt")/(1024*1000)
cat("The household_power_consumption.txt file is ",checksize, " MB big.")

###Reading textfile while selecting the relevant rows of data, merging the date and time vector
###into POSIXct values, and inserting it as a new column (datetime) and removing the old date and time columns.
message("reading the [2880,9] values from household_power_consumption.txt")
hpc<-read.table("household_power_consumption.txt",sep=";",header=F,skip=66637,nrow=2880)
colnames(hpc)<-colnames(read.table("household_power_consumption.txt",sep=";",header=T,nrow=1))
datetime<-strptime(paste(hpc[,1],hpc[,2]),format = "%d/%m/%Y %H:%M:%S")
hpc<-cbind(datetime,hpc[,-c(1,2)])

##choosing the png graphic device with appropriate dimensions
png(filename = "plot4.png", width=480,height=480)

##Setting the page to contain 2x2 plot windows
par(mfrow=c(2,2))

##drawing the four plots in one window
with(hpc, plot(Global_active_power~datetime, xlab="",
               ylab = "Global Active Power",type='l'))

with(hpc, plot(Voltage~datetime,type = 'l'))

with(hpc, plot(Sub_metering_1~datetime,type='l',ylab="Energy sub metering",xlab=""))
lines(x=hpc[,1],y=hpc[,7],col="red")
lines(x=hpc[,1],y=hpc[,8],col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1, bty="n")

with(hpc, plot(Global_reactive_power~datetime,type = 'l'))

##closing graphic device
dev.off()