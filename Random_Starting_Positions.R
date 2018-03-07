arguments <- commandArgs(trailingOnly = TRUE)

pop_size_scale_factor <- as.numeric(arguments[[1]])

base_pop_AAhungry <- 25
base_pop_AAfull <- 20
base_pop_ABhungry <- 50
base_pop_ABfull <- 40
base_pop_BBhungry <- 25
base_pop_BBfull <- 20
base_food <- 180

pop_AAhungry <- base_pop_AAhungry * pop_size_scale_factor
pop_AAfull <- base_pop_AAfull * pop_size_scale_factor
pop_ABhungry <- base_pop_ABhungry * pop_size_scale_factor
pop_ABfull <- base_pop_ABfull * pop_size_scale_factor
pop_BBhungry <- base_pop_BBhungry * pop_size_scale_factor
pop_BBfull <- base_pop_AAfull * pop_size_scale_factor
food <- base_food * pop_size_scale_factor

AAhungry_x_pos <- runif(pop_AAhungry, min=(-50 * pop_size_scale_factor^0.5), max = (250*pop_size_scale_factor^0.5))
AAhungry_y_pos <- runif(pop_AAhungry, min=(-50 * pop_size_scale_factor^0.5), max = (50*pop_size_scale_factor^0.5))

AAfull_x_pos <- runif(pop_AAfull, min=(-50 * pop_size_scale_factor^0.5), max = (250*pop_size_scale_factor^0.5))
AAfull_y_pos <- runif(pop_AAfull, min=(-50 * pop_size_scale_factor^0.5), max = (50*pop_size_scale_factor^0.5))

ABhungry_x_pos <- runif(pop_ABhungry, min=(-50 * pop_size_scale_factor^0.5), max = (250*pop_size_scale_factor^0.5))
ABhungry_y_pos <- runif(pop_ABhungry, min=(-50 * pop_size_scale_factor^0.5), max = (50*pop_size_scale_factor^0.5))

ABfull_x_pos <- runif(pop_ABfull, min=(-50 * pop_size_scale_factor^0.5), max = (250*pop_size_scale_factor^0.5))
ABfull_y_pos <- runif(pop_ABfull, min=(-50 * pop_size_scale_factor^0.5), max = (50*pop_size_scale_factor^0.5))

BBhungry_x_pos <- runif(pop_BBhungry, min=(-50 * pop_size_scale_factor^0.5), max = (250*pop_size_scale_factor^0.5))
BBhungry_y_pos <- runif(pop_BBhungry, min=(-50 * pop_size_scale_factor^0.5), max = (50*pop_size_scale_factor^0.5))

BBfull_x_pos <- runif(pop_BBfull, min=(-50 * pop_size_scale_factor^0.5), max = (250*pop_size_scale_factor^0.5))
BBfull_y_pos <- runif(pop_BBfull, min=(-50 * pop_size_scale_factor^0.5), max = (50*pop_size_scale_factor^0.5))

food_x_pos <- runif(food, min=(-50 * pop_size_scale_factor^0.5), max = (250*pop_size_scale_factor^0.5))
food_y_pos <- runif(food, min=(-50 * pop_size_scale_factor^0.5), max = (50*pop_size_scale_factor^0.5))

positions <- rbind(cbind('mol','1','AAhungry',AAhungry_x_pos,AAhungry_y_pos),cbind('mol','1','AAfull',AAfull_x_pos,AAfull_y_pos), cbind('mol','1','ABhungry',ABhungry_x_pos,ABhungry_y_pos),cbind('mol','1','ABfull',ABfull_x_pos,ABfull_y_pos),cbind('mol','1','BBhungry',BBhungry_x_pos,BBhungry_y_pos),cbind('mol','1','BBfull',BBfull_x_pos,BBfull_y_pos),cbind('mol','1','food',food_x_pos,food_y_pos))
write.table(positions, paste0('~/Documents/Mini_Project/starting_positions_',arguments[[2]],'.txt'), sep=' ', row.names=FALSE,col.names=FALSE,quote=FALSE)
