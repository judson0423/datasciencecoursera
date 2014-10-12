
## All files must be in the user's working directory or code modifications will be required.

hhPwrCons_Base <- read.table("household_power_consumption.txt", header=T, sep=";", stringsAsFactors=F)

        Date2 <- as.Date(hhPwrCons_Base$Date, "%d/%m/%Y")
        hhPwrCons_2day <- cbind(hhPwrCons_Base, Date2)
        hhPwrCons_2day <- hhPwrCons_2day[(hhPwrCons_2day$Date2 == "2007-02-01") | (hhPwrCons_2day$Date2 == "2007-02-02"),]

        Global_Active_Power <- as.numeric(hhPwrCons_2day$Global_active_power)

dev.copy(png, file="plot1.png")
hist(Global_Active_Power, col="red", main="Global Active Power", xlab="kw Global Active Power")
dev.off()
rm(list=ls())