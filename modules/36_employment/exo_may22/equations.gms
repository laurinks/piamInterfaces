*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de


*' @equations

*' Employment is calculated as total labor costs devided by hourly labor costs and 
*' average hours worked per employed person per year. Total labor costs include
*' labor costs from crop production (see [38_factor_costs]) and livestock production 
*' (see [70_livestock]), as well as the labor cost share of subsidies and from livestock
*' categories not covered by MAgPIE (i.e. wool, beeswax, honey, silk-worms), which 
*' are both kept constant over time. 
* excluding labor costs for crop residues (as this is not include in ILO empl. data)
* and fish (as we cannot calibrate labor costs for fish to employment data)

q36_employment(i2) .. v36_employment(i2)
                              =e= (vm_cost_prod_crop(i2,"labor") + vm_cost_prod_livst(i2,"labor") + sum(ct,p36_nonmagpie_labor_costs(ct,i2))) / 
                                         sum(ct,f36_weekly_hours(ct,i2)*52.1429*p36_hourly_costs(ct,i2));