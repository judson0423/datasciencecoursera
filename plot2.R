
# All files must be in the user's working directory or code modifications will be required.

hhPwrCons_Base <- read.table("household_power_consumption.txt", header=T, sep=";", stringsAsFactors=F)

        Date2 <- as.Date(hhPwrCons_Base$Date, "%d/%m/%Y")
        hhPwrCons_2day <- cbind(hhPwrCons_Base, Date2)
        hhPwrCons_2day <- hhPwrCons_2day[(hhPwrCons_2day$Date2 == "2007-02-01") | (hhPwrCons_2day$Date2 == "2007-02-02"),]

                Global_Active_Power <- as.numeric(hhPwrCons_2day$Global_active_power)

        dateTime <- as.POSIXct(paste(hhPwrCons_2day$Date, hhPwrCons_2day$Time), format = "%d/%m/%Y %T")

dev.set(2)
dev.copy(png, file="plot2.png")

plot(Global_Active_Power ~ dateTime, cex=0, ylab="kw Global Active Power", xlab="")
lines(dateTime, Global_Active_Power, type="l")

dev.off(dev.cur())
rm(list=ls())