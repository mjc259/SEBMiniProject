library(ggplot2)
library(tidyverse)
library(gridExtra)
library(data.table)


### Running in OS
setwd('~/../Desktop/Mini-Project')

k <- 1

CurrentFiles <- list.files('./Testing')
if(length(CurrentFiles) > 0){
  file.remove(paste0('./Testing/',CurrentFiles))
}

Generation_Time <- 3935
Step_base <- 0.1
GenMax <- 10


for(i in 1:k){
  system2(command = 'smoldyn', args = paste0('SmoldynEffectiveMigrationv3.txt', 
                                             ' --define Generation_Time=',Generation_Time,
                                             ' --define Ending=',GenMax,
                                             ' --define Stepping=',format(signif(Step_base/Generation_Time, 3), scientific = F),
                                             ' --define Number=',i,
                                             ' -twq'))
}




### Actual migration bit
setwd('~/../Desktop/Mini-Project/Testing')

files <- list.files(pattern = 'Species')
Migration <- data.frame()
for(file in files){ 
 
  Species <- read.table(file)
  Species <- Species[,c(1,2,4,6)]
  colnames(Species) <- c('Replicate', 'Type', 'X', 'Num')
  
  Tule <- Species %>% filter(X >= -50) %>% filter(X < 50) %>% mutate(compartment = 'Tule')
  Lava <- Species %>% filter(X >= 50) %>% filter(X < 150) %>% mutate(compartment = 'Lava')
  ONeils <- Species %>% filter(X >= 150) %>% filter(X <= 250) %>% mutate(compartment = 'ONeils')
  
  Whole <- rbind(Tule, Lava, ONeils)
  Whole <- Whole %>% filter(Type %in% 1:6)
  Whole$Type <- gsub('1', 'AA', Whole$Type)
  Whole$Type <- gsub('2', 'AA', Whole$Type)
  Whole$Type <- gsub('3', 'AB', Whole$Type)
  Whole$Type <- gsub('4', 'AB', Whole$Type)
  Whole$Type <- gsub('5', 'BB', Whole$Type)
  Whole$Type <- gsub('6', 'BB', Whole$Type)
  Whole <- Whole[sort(Whole$Replicate, index.return = T)$ix,]
  
  Gens <- sort(unique(Whole$Replicate))

  MRates <- c(0,0,0,0,0,0)
  
  Diploid <- list(c('AA','AB'),'BB')
  
  for(Dips in Diploid){
    
    DipCo <- which(Whole$Type %in% unlist(Dips), arr.ind = T)
  
    Migrate <-  t(data.frame(c(0,0,0),c(0,0,0)))
    Sizes <- mat.or.vec(nr=GenMax, nc = 3)
    
    for(i in 1:GenMax){
      
      GenPrior <- Whole[DipCo,] %>% filter(Replicate == i)
      GenPost <- Whole[DipCo,] %>% filter(Replicate == (i+1))
      
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
    if(dim(Migrate)[1] > 2){
      Migrate <- Migrate[-1,]
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
      Denom <- Denom[MCounts$Gen,]
      
      MRate <- MCountsNG/Denom
      MRate[is.na(MRate)] <- 0
      MeanMRate <- colMeans(MRate)
    } else {
      MeanMRate <- t(as.data.frame(rep(0,6)))
      } 
    MRates <- rbind(MRates,MeanMRate)
  }
  MRates <- MRates[-1,]
  Rep <- which(files == file, arr.ind = T)
  MRates <- cbind(c(paste0(Rep, 'a'),paste0(Rep,'b')),c('AA&AB', 'BB'), MRates)
  Mrates <- data.frame(MRates)
  colnames(Mrates)[1:2] <- c('Replicate', 'Diploids')
  Migration <- rbind(Migration,Mrates)
#})
}

for(i in 3:8){
  Migration[,i] <- as.character(Migration[,i])
  Migration[,i] <- as.numeric(Migration[,i])
  Migration[,i] <- signif(Migration[,i], digits = 3)
}

for(i in 1:2){
  Migration[,i] <- as.character(Migration[,i])
}  
Migration[,3:8] 
  
