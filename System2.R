setwd('~/../Desktop/Mini-Project/Thursday Night/')

k <- 20

Generation_Time <- 3935
Step_base <- 0.2
GenMax <- 200

for(j in c(100, 50, 10, 5, 1, 0.5, 0.1, 0.05, 0.01)){
  for(i in 1:k){
    pop_size_scale_factor <- as.numeric(1)
    compartment_size_scale_factor <- as.numeric(1)
    iteration <- i
    
    base_pop_AA_Tule <- 0
    base_pop_AA_Lava <- 74
    base_pop_AA_ONeill <- 11
    base_pop_AB_Tule <- 6
    base_pop_AB_Lava <- 24
    base_pop_AB_ONeill <- 45
    base_pop_BB_Tule <- 94
    base_pop_BB_Lava <- 2
    base_pop_BB_ONeill <- 44
    base_food <- 92
    
    pop_AA_Tule <- base_pop_AA_Tule * pop_size_scale_factor
    pop_AA_Lava <- base_pop_AA_Lava * pop_size_scale_factor
    pop_AA_ONeill <- base_pop_AA_ONeill * pop_size_scale_factor
    pop_AB_Tule <- base_pop_AB_Tule * pop_size_scale_factor
    pop_AB_Lava <- base_pop_AB_Lava * pop_size_scale_factor
    pop_AB_ONeill <- base_pop_AB_ONeill * pop_size_scale_factor
    pop_BB_Tule <- base_pop_BB_Tule * pop_size_scale_factor
    pop_BB_Lava <- base_pop_BB_Lava * pop_size_scale_factor
    pop_BB_ONeill <- base_pop_BB_ONeill * pop_size_scale_factor
    food <- base_food * pop_size_scale_factor
    
    
    AALava_x_pos <- runif(pop_AA_Lava, min=(50 * compartment_size_scale_factor^0.5), max = (150*compartment_size_scale_factor^0.5))
    AALava_y_pos <- runif(pop_AA_Lava, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    AAONeill_x_pos <- runif(pop_AA_ONeill, min=(150 * compartment_size_scale_factor^0.5), max = (250*compartment_size_scale_factor^0.5))
    AAONeill_y_pos <- runif(pop_AA_ONeill, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    ABTule_x_pos <- runif(pop_AB_Tule, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    ABTule_y_pos <- runif(pop_AB_Tule, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    ABLava_x_pos <- runif(pop_AB_Lava, min=(50 * compartment_size_scale_factor^0.5), max = (150*compartment_size_scale_factor^0.5))
    ABLava_y_pos <- runif(pop_AB_Lava, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    ABONeill_x_pos <- runif(pop_AB_ONeill, min=(150 * compartment_size_scale_factor^0.5), max = (250*compartment_size_scale_factor^0.5))
    ABONeill_y_pos <- runif(pop_AB_ONeill, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    BBTule_x_pos <- runif(pop_BB_Tule, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    BBTule_y_pos <- runif(pop_BB_Tule, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    BBLava_x_pos <- runif(pop_BB_Lava, min=(50 * compartment_size_scale_factor^0.5), max = (150*compartment_size_scale_factor^0.5))
    BBLava_y_pos <- runif(pop_BB_Lava, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    BBONeill_x_pos <- runif(pop_BB_ONeill, min=(150 * compartment_size_scale_factor^0.5), max = (250*compartment_size_scale_factor^0.5))
    BBONeill_y_pos <- runif(pop_BB_ONeill, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    food_x_pos <- runif(food, min=(-50 * compartment_size_scale_factor^0.5), max = (250*compartment_size_scale_factor^0.5))
    food_y_pos <- runif(food, min=(-50 * compartment_size_scale_factor^0.5), max = (50*compartment_size_scale_factor^0.5))
    
    positions <- rbind(cbind('mol','1','AAhungry',AALava_x_pos,AALava_y_pos),cbind('mol','1','AAhungry',AAONeill_x_pos,AAONeill_y_pos),cbind('mol','1','ABhungry',ABTule_x_pos,ABTule_y_pos),cbind('mol','1','ABhungry',ABLava_x_pos,ABLava_y_pos),cbind('mol','1','ABhungry',ABONeill_x_pos,ABONeill_y_pos),cbind('mol','1','BBhungry',BBTule_x_pos,BBTule_y_pos),cbind('mol','1','BBhungry',BBLava_x_pos,BBLava_y_pos),cbind('mol','1','BBhungry',BBONeill_x_pos,BBONeill_y_pos), cbind('mol', '1', 'food', food_x_pos, food_y_pos))
    write.table(positions, paste0('./migration_starting_positions_', iteration,'.txt'), sep=' ', row.names=FALSE,col.names=FALSE,quote=FALSE)
    
    system2(command = 'smoldyn', args = paste0('SmoldynMigrationThursdayOvernight.txt', 
                                               ' --define Generation_Time=',Generation_Time,
                                               ' --define Ending=',GenMax,
                                               ' --define Stepping=',format(signif(Step_base/Generation_Time, 3), scientific = F),
                                               ' --define SIMNUM=',i,
                                               ' --define MigrationCheck=',0.1,
                                               ' --define Mconst=',j,
                                               ' -twq'))
  }
}

