ExtractMostRelevantCoefficient <- function(singleModel) {
  # This function extracts for each country the most relevant coefficient in 
  # terms of absolute value, and save it into a data table.
  # 
  # ARGS
  # - singleModel [model]  the model from which one wants to extract the 
  #                        coefficients
  # 
  # RETURN
  # - dt  [data table]  a data table with the name of the coefficient, its value,
  #                     and the associated country
  
  dt <- data.table()
  
  # For each country
  for(country in 1:length(singleModel)) { 
    precisModel <- precis(singleModel[[country]])
    
    # Select intervals not containing 0
    valueWithZero <- precisModel[[3]][-1] <= 0 & precisModel[[4]][-1] >= 0
    selectValue <- precisModel[[1]][-1][valueWithZero == FALSE]
    
    if (length(selectValue) > 0) {
      # Find the maximum among the coefficients (no intercept)
      maxCoef <- max(abs(selectValue))
      
      # Find the row of the associated coefficent
      mainCoeff <- precisModel[abs(precisModel$mean) == maxCoef, ]

      tmp <- data.table(name = row.names(mainCoeff), 
                        mainCoef = mainCoeff[[1]],
                        country = names(singleModel)[[country]])
    } else {
      tmp <- data.table(name = "NA",
                        mainCoef = NA,
                        country = names(singleModel)[[country]])
    }
    
    dt <- rbind(dt, tmp)
  }
  
  
  return(dt)
}