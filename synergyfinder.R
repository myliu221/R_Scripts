#BiocManager::install("synergyfinder",force = TRUE)
library(synergyfinder)

setwd("/Users/mingyu.liu001/Desktop/CPCT-UMASS/BRD4_results/synergyfinder/")
# data("mathews_screening_data")
# head(mathews_screening_data)
# 
# write.csv(mathews_screening_data, file="mathews_screening_data.csv")
# 
# set.seed(1234)
# dose.response.mat <- ReshapeData(mathews_screening_data,
#                                  data.type = "viability",
#                                  impute = TRUE,
#                                  noise = TRUE,
#                                  correction = "non")
# 
# dose.response.mat$dose.response.mats
# 
# PlotDoseResponse(dose.response.mat, save.file = TRUE)
# graphics.off()
# ?PlotDoseResponse()
# 
# synergy.score <- CalculateSynergy(data = dose.response.mat,
#                                   method = "ZIP")
# 
# 
# PlotSynergy(synergy.score, type = "3D",save.file = TRUE)
# 
# ?PlotSynergy()



data <- read.csv("22RV1_GSK_Indo_5Day_proliferation_7-24-23.csv")

data$response <- data$response/data$response[1]*100

# write.csv(data, file="22RV1_proliferation_ORY_IBET762_0804_4days_normalized.csv")

# set.seed(1234)
dose.response.mat <- ReshapeData(data,
                                 data_type = "viability",
                                 impute = TRUE,
                                 impute_method = NULL,
                                 noise = TRUE,
                                 seed = 1234)

dose.response.mat[["response"]]$response <- as.numeric(sprintf(dose.response.mat[["response"]]$response, fmt = '%#.2f'))

#PlotDoseResponse(dose.response.mat)

synergy.score <- CalculateSynergy(data = dose.response.mat,
                                  method = "Bliss",
                                  iteration = 10,
                                  correct_baseline = "non")

#synergy.score$response[,4] <- as.numeric(synergy.score$response[,4])

pdf(file="Synergy_22RV1_GSK_Indo_5Day_proliferation_7-24-23.pdf")
# Dose-response curve
for (i in c(1, 2)){
  PlotDoseResponseCurve(
    data = synergy.score,
    plot_block = 1,
    drug_index = i,
    plot_new = FALSE,
    record_plot = FALSE
  )
}

# 2D heatmap
Plot2DrugHeatmap(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  statistic = NULL,
  dynamic = FALSE, color_range = c(10,80), high_value_color = "red", low_value_color = "white",
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)

Plot2DrugHeatmap(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "Bliss_synergy",
  dynamic = FALSE, 
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)

# 2D contour plot
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "Bliss_synergy",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)

# 3D surface plot
Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)

Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "Bliss_synergy",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
dev.off() 



