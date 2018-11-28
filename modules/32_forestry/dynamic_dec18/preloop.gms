*v32_hvarea_forestry.fx(j,kforestry,"ac0") = 0;

** Read exogenous rotation length
p32_rot_length(i) = f32_rot_length(i,"%c32_rot_length%");
pm_rot_length(i) = p32_rot_length(i);
** rotation length in 5 year time steps
p32_rotation_cellular(j) = sum(cell(i,j), ceil(p32_rot_length(i)/5));
display p32_rotation_cellular;

*' @code
*' Mapping between AC, type32 and Rotation length
*' Forests are moved to categories of type32 based the rotation lengths.
*ac_land32(j,ac,"aff") = yes$(ord(ac) > 1);
*ac_land32(j,ac,"indc") = yes$(ord(ac) > 1);

*' @stop
protect32(j,ac) = no;
protect32(j,ac) = yes$(ord(ac) < p32_rotation_cellular(j));

harvest32(j,ac) = no;
harvest32(j,ac) = yes$(ord(ac) >= p32_rotation_cellular(j));

*harvest32(j,ac) = yes$(ord(ac) >= sum(cell(i,j), ceil(p32_rot_length(i)/5)));


** Initialization of "Protected available plantations" and "availabe plantations which can be re-used".
p32_protect_avail(t,j) = 0;
v32_avail_reuse.l(j) = 0;

** Exoenously determine timber demand is fed into interface vm_prod_reg which is used to equate demand with supply.
vm_prod_reg.l(i,kforestry) = fm_forestry_demand("y1995",i,kforestry);

** Afforestation policies NPI and NDCs
p32_aff_pol(t,j) = f32_aff_pol(t,j,"%c32_aff_policy%");
p32_land(t,j,type32,ac) = 0;

** divide initial forestry area by number of age classes within protect32
** since protect32 is TRUE for ord(ac) < p32_rotation_cellular(j) there is one additional junk which is assigned to ac0
p32_plant_ini_ac(j) = pm_land_start(j,"forestry")/p32_rotation_cellular(j);
*p32_plant_ini_ac(j) = pm_land_start(j,"forestry")/sum(cell(i,j), ceil(f32_rot_length(i,"init")/5));

p32_land("y1995",j,"plant",ac)$(protect32(j,ac)) = p32_plant_ini_ac(j);
p32_land("y1995",j,"plant","ac0") = p32_plant_ini_ac(j);

** initial shifting of age classes
p32_land(t,j,"plant",ac)$(ord(ac) > 1) = p32_land(t,j,"plant",ac-1);
** reset ac0 to zero
p32_land("y1995",j,"plant","ac0") = 0;

**************************************************************************************
pm_production_ratio_ext(i,t_ext) = fm_production_ratio(i,"y2150");
pm_production_ratio_ext(i,t_all) = fm_production_ratio(i,t_all);

p32_forestry_management(i) = f32_forestry_management(i)+1;
p32_forestry_management("IND") = 10;
*p32_forestry_management("CHA") = 7;
p32_forestry_management("MEA") = 200;

f32_fac_req_ha(i2,"recur") = 100;
f32_fac_req_ha(i2,"mon") = 33;
fm_harvest_cost_ha(i2)  = 300;

**************************************************************************
