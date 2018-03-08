setwd('~/../Desktop/Mini-Project')
library(ggplot2)
library(tidyverse)
library(gridExtra)
library(data.table)

k <- 10

CurrentFiles <- list.files('./Testing')
if(length(CurrentFiles) > 0){
  file.remove(paste0('./Testing/',CurrentFiles))
}

Generation_Time <- 3935
Step_base <- 0.1
GenMax <- 100


for(i in 1:k){
  system2(command = 'smoldyn', args = paste0('SmoldynEffectiveMigrationv2.txt', 
                                             ' --define Generation_Time=',Generation_Time,
                                             ' --define Ending=',GenMax,
                                             ' --define Stepping=',format(signif(Step_base/Generation_Time, 3), scientific = F),
                                             ' --define Number=',i,
                                             ' -twq'))
}

setwd('~/../Desktop/Mini-Project/Testing')


GenMax <- 100
files <- list.files(pattern = 'Species')
MRates <- lapply(files, function(file){
  
  Species <- read.table(file)
  Species <- Species[,c(1,2,4,6)]
  colnames(Species) <- c('Replicate', 'Type', 'X', 'Num')
  
  Tule <- Species %>% filter(X >= -50) %>% filter(X < 50) %>% mutate(compartment = 'Tule')
  Lava <- Species %>% filter(X >= 50) %>% filter(X < 150) %>% mutate(compartment = 'Lava')
  ONeils <- Species %>% filter(X >= 150) %>% filter(X <= 250) %>% mutate(compartment = 'ONeils')
  
  Whole <- rbind(Tule, Lava, ONeils)
  Whole <- Whole %>% filter(Type %in% 1:6)
  Whole <- Whole[sort(Whole$Replicate, index.return = T)$ix,]
  
  Gens <- sort(unique(Whole$Replicate))

  Migrate <- c(0,0,0)
  Sizes <- mat.or.vec(nr=GenMax, nc = 3)
  
  for(i in 1:GenMax){
    
    GenPrior <- Whole %>% filter(Replicate == i)
    GenPost <- Whole %>% filter(Replicate == (i+1))
    
    for(j in GenPrior$Num){
      
      if(j %in% GenPost$Num){
        
        if(GenPrior[which(GenPrior$Num == j, arr.ind = T),5] != GenPost[which(GenPost$Num == j, arr.ind = T),5]){
          
          PrC <- GenPrior[which(GenPrior$Num == j, arr.ind = T),5]
          PoC <- GenPost[which(GenPost$Num == j, arr.ind = T),5]
          Migrate <- rbind(Migrate,c(i,PrC,PoC))
          
        }
        
      }
      
    }
    
    PopTab <- table(GenPrior[,5])
    
    if(length(unname(PopTab)) == 3){
      
      Sizes[i,] <- unname(PopTab)
    
      } else {
        
      if(sum(names(PopTab) == 'Lava') > 0){
        
        Sizes[i,1] <- PopTab[names(PopTab) == 'Lava']
      
        }
      
        if(sum(names(PopTab) == 'ONeils') > 0){
        
          Sizes[i,2] <- PopTab[names(PopTab) == 'ONeils']
      
          }
      
        if(sum(names(PopTab) == 'Tule') > 0){
        
          Sizes[i,3] <- PopTab[names(PopTab) == 'Tule']
      
          }
    
        }
  
    }
  
  Migrate <- Migrate[-1,]
  Migrate <- data.frame(Migrate)
  Migrate$X1 <- as.character(Migrate$X1)
  Migrate$X1 <- as.integer(Migrate$X1)
  Migrate$X2 <- as.character(Migrate$X2)
  Migrate$X3 <- as.character(Migrate$X3)
  colnames(Migrate) <- c('Gen', 'Prior', 'Post')
  
  colnames(Sizes) <- c('Lava', 'ONeils','Tule')
  
  MCounts <- Migrate %>% group_by(Gen) %>% summarise(
    L2T = sum(Prior == 'Lava' & Post == 'Tule'),
    L2O = sum(Prior == 'Lava' & Post == 'ONeils'),
    
    O2L = sum(Prior == 'ONeils' & Post == 'Lava'),
    O2T = sum(Prior == 'ONeils' & Post == 'Tule'),
    
    T2L = sum(Prior == 'Tule' & Post == 'Lava'),
    T2O = sum(Prior == 'Tule' & Post == 'ONeils')
  )
  MCountsNG <- as.matrix(MCounts[,2:7])
  
  Denom <- cbind(Sizes, Sizes)[,c(1,4,2,5,3,6)]
  Denom <- Denom[1:dim(MCountsNG)[1],]
  
  MRates <- MCountsNG/Denom
  MRates[is.na(MRates)] <- 0
  colMeans(MRates)

})

