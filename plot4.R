
# All files must be in the user's working directory or code modifications will be required.

hhPwrCons_Base <- read.table("household_power_consumption.txt", header=T, sep=";", stringsAsFactors=F)

Date2 <- as.Date(hhPwrCons_Base$Date, "%d/%m/%Y")
hhPwrCons_2day <- cbind(hhPwrCons_Base, Date2)
hhPwrCons_2day <- hhPwrCons_2day[(hhPwrCons_2day$Date2 == "2007-02-01") | (hhPwrCons_2day$Date2 == "2007-02-02"),]

Global_Active_Power <- as.numeric(hhPwrCons_2day$Global_active_power)
Sub_metering_1 <- as.numeric(hhPwrCons_2day$Sub_metering_1)
Sub_metering_2 <- as.numeric(hhPwrCons_2day$Sub_metering_2)
Sub_metering_3 <- as.numeric(hhPwrCons_2day$Sub_metering_3)
Voltage <- as.numeric(hhPwrCons_2day$Voltage)
Global_Reactive_Power <- as.numeric(hhPwrCons_2day$Global_reactive_power)


dateTime <- as.POSIXct(paste(hhPwrCons_2day$Date, hhPwrCons_2day$Time), format = "%d/%m/%Y %T")


dev.set(2)
dev.copy(png, file="plot4.png")

par(mfrow=c(2,2))
par(mar=c(2,4,2,2))

plot(Global_Active_Power ~ dateTime, cex=0, ylab="kw Global Active Power", xlab="")
lines(dateTime, Global_Active_Power, type="l")

plot(Voltage ~ dateTime, ylab="Voltage", xlab="", cex=0)
lines(dateTime, Voltage, type="l", lwd=1, col="black")

plot(Sub_metering_1 + Sub_metering_2 + Sub_metering_3 ~ dateTime, col=c("black", "red", "blue"), cex=0, ylab="Energy sub-metering", xlab="")
lines(dateTime, Sub_metering_1, type="l", col="black")
lines(dateTime, Sub_metering_2, type="l", col="red")
lines(dateTime, Sub_metering_3, type="l", col="blue")
legend("topright", c("S_m1", "S_m2", "S_m3"), pch=20, cex=1.5, col=c("black", "red", "blue"))

plot(Global_Reactive_Power ~ dateTime, ylab="Global Reactive Power", xlab="", cex=0)
lines(dateTime, Global_Reactive_Power, type="l", lwd=1, col="black")

dev.off(dev.cur())
rm(list=ls())
