setwd('~/../Desktop/Mini-Project')
library(ggplot2)
library(tidyverse)
library(gridExtra)
library(data.table)

# s <- seq(-1, 1, 0.2)
# 
# for(i in 1:length(s)){
#   system2(command = 'smoldyn', args = paste0('SmoldynLava.txt --define R2s22="',s[i],'" -twq'), stdout = paste0('test',i,'.txt'))
#   #cat(s[i],'\n')
# }

k <- 3

CurrentFiles <- list.files(pattern = 'testv5')
if(length(CurrentFiles) > 0){
  file.remove(CurrentFiles)
}

Generation_Time <- 3620
End_base <- 1000000
Step_base <- 0.1

for(i in 1:k){
  system2(command = 'smoldyn', args = paste0('SmoldynLavaGeneration.txt --define Generation_Time=',Generation_Time,' --define Ending=',signif(End_base/Generation_Time, 3),' --define Stepping=',format(signif(Step_base/Generation_Time, 3), scientific = F),' -twq'), stdout = paste0('testv5',i,'.txt'))
  #cat(s[i],'\n')
}

Files <- list.files(pattern = 'testv5')

dat <- lapply(1:k, function(i){
  fil <- Files[i]
  y <- read.table(fil)
  y <- cbind(y, rep(i, length(y$V1)))
  colnames(y) <- c('time', 'AAfullTule', 'AAhungryTule', 'ABfullTule', 'ABhungryTule', 'BBfullTule',
                   'BBhungryTule', 'AAAATule', 'AAABTule', 'ABABTule', 'AABBTule','ABBBTule',
                   'BBBBTule', 'foodTule', 'AAfullLava', 'AAhungryLava', 'ABfullLava', 'ABhungryLava', 'BBfullLava',
                   'BBhungryLava', 'AAAALava', 'AAABLava', 'ABABLava', 'AABBLava','ABBBLava', 
                   'BBBBLava', 'foodLava', 'AAfullONeils', 'AAhungryONeils', 'ABfullONeils', 'ABhungryONeils', 'BBfullONeils',
                   'BBhungryONeils', 'AAAAONeils', 'AAABONeils', 'ABABONeils', 'AABBONeils','ABBBONeils', 
                   'BBBBONeils', 'foodONeils', 'Replicate')
  y
})

dat <- rbindlist(dat)
dat <- as.data.frame(dat)
Total <- rowSums(dat[,c(2:7, 15:20, 28:33)])
plot(Total)
dat <- cbind(dat, Total)
Variance <- dat %>% group_by(Replicate) %>% summarise(Var = var(Total))
boxplot(Variance$Var)

Species <- rowSums(dat[,c(2:7, 15:20, 28:33)])
plot(Species)
signif(c(mean(Species), var(Species)), 3)
boxplot(Species)
qqnorm(Species)
qqline(Species)

Time <- dat[,1]
Tule <- dat[,2:14]
Lava <- dat[,15:27]
ONeils <- dat[,28:40]

A <- rowSums(2*Tule[,2:3]) + rowSums(Tule[,4:5])
B <- rowSums(2*Tule[,6:7]) + rowSums(Tule[,4:5])
Afreq <- A/(A+B)
Bfreq <- B/(A+B)
AlleleFreq <- data.frame(Afreq,Bfreq,Time)
AlleleFreqTule <- gather(AlleleFreq, 'Allele', 'Frequency', 1:2)
colnames(AlleleFreqTule)[1] <- 'Time'
ggTule <- ggplot(AlleleFreqTule, mapping = aes (x = Time, y = Frequency)) + geom_line(aes(colour = factor(Allele))) + ggtitle('Tule')

A <- rowSums(2*Lava[,2:3]) + rowSums(Lava[,4:5])
B <- rowSums(2*Lava[,6:7]) + rowSums(Lava[,4:5])
Afreq <- A/(A+B)
Bfreq <- B/(A+B)
AlleleFreq <- data.frame(Afreq,Bfreq,Time)
AlleleFreqLava <- gather(AlleleFreq, 'Allele', 'Frequency', 1:2)
colnames(AlleleFreqLava)[1] <- 'Time'
ggLava <- ggplot(AlleleFreqLava, mapping = aes (x = Time, y = Frequency)) + geom_line(aes(colour = factor(Allele))) + ggtitle('Lava')

A <- rowSums(2*ONeils[,2:3]) + rowSums(ONeils[,4:5])
B <- rowSums(2*ONeils[,6:7]) + rowSums(ONeils[,4:5])
Afreq <- A/(A+B)
Bfreq <- B/(A+B)
AlleleFreq <- data.frame(Afreq,Bfreq,Time)
AlleleFreqONeils <- gather(AlleleFreq, 'Allele', 'Frequency', 1:2)
colnames(AlleleFreqONeils)[1] <- 'Time'
ggONeils <- ggplot(AlleleFreqONeils, mapping = aes (x = Time, y = Frequency)) + geom_line(aes(colour = factor(Allele))) + ggtitle('ONeils')

grid.arrange(ggTule, ggLava, ggONeils)

# data <- dat[,c(2:7)]
# AlleleCount <- gather(data, 'Allele', 'Count', 1:6)
# AlleleCount <- cbind(rep(dat[,1], times = 6), AlleleCount)
# colnames(AlleleCount)[1] <- 'Time'
# ggplot(AlleleCount, mapping = aes (x = Time, y = Count)) + geom_smooth(aes(colour = factor(Allele)))

