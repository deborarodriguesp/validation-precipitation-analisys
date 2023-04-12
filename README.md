# validation-precipitation-analisys
Script developed following the WMO guidelines for Climate data: 

"Estimated or accumulated data do not represent 11 or
more days during the month, or 5 or more consecutive days during the month"

You can check the guidelines on: https://library.wmo.int/doc_num.php?explnum_id=4166

Here, we compared observed and reanalisys model results.
The script is diveded in two sections. The first we remove from analisys months with more than 11 days of missing data. 

The second part is the validation analisys, which we compare the observation and models 
using Performance metrics, such as RMSE, NSE, PBIAS, R, R2.
