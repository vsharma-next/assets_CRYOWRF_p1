!---------------------------------------------------------------------------------------
! Example 27: GRIB1 output of COSMO-7 wind components and temperature on the geographical 
!             lat/lon grid over Switzerland.
!---------------------------------------------------------------------------------------
! Features (see README.user):
!---------------------------------------------------------------------------------------
!             GRIB1 output                                            (4.3.4, 8.3)
!             Usage of out_type="INCORE" to specify model base 
!             grid when working with fields on staggered grid         (4.3.2)
!             Re-gridding staggered fields to model base grid, using 
!             in_regrid_target and in_regrid_method                   (4.3.2)
!             Re-gridding of fields on output, using 
!             out_regrid_target and out_regrid_method                 (4.3.2)
!             Usage of source level list levlist                      (4.3.3, 4.3.5)
!             Time loop construct for input files                     (4.3.1)
!             Just-on-time mode                                       (2, 4.3.1, 8.10)
!             Point operator poper="n2geog"                           (4.3.4, 4.3.5)
!---------------------------------------------------------------------------------------

!---------------------------------------------------------------------------------------
! Global specifications (compulsive):
!---------------------------------------------------------------------------------------
&RunSpecification
 verbosity = 'moderate'
 soft_memory_limit = 100
 n_ompthread_total     = 36
 n_ompthread_collect   = 1
 n_ompthread_generate  = 12
/

&GlobalResource
   dictionary           = "/users/bettems/projects/fieldextra/resources/dictionary_cosmo.txt",
   grib_definition_path = "/users/bettems/projects/fieldextra/resources/eccodes_definitions_cosmo",
                          "/users/bettems/projects/fieldextra/resources/eccodes_definitions_vendor"
   grib2_sample         = "/users/bettems/projects/fieldextra/resources/eccodes_samples/COSMO_GRIB2_default.tmpl"
  /

&GlobalSettings
 default_model_name    = "cosmo"
/

&ModelSpecification
 model_name         = "cosmo"
 earth_axis_large   = 6371229.
 earth_axis_small   = 6371229.
/

!---------------------------------------------------------------------------------------
! "INCORE" fields:
! The field "HSURF" is required to specify the model base grid when working with fields
! defined on a staggered grid. Specification of in_regrid_method is necessary, since the
! wind components have to be explicitely re-gridded for further transformation.
!---------------------------------------------------------------------------------------
&Process 
  in_file   = "/scratch/lbraud/COSMO-1/ANA1819/laf2019030600"
  out_type = "INCORE" 
/
&Process in_field    = "HSURF", tag='masspoint' /

&Process
  in_regrid_all = .true.
  in_type = "INCORE"
  in_regrid_target = "masspoint"
  in_regrid_method = "average,square,0.9"
  out_type = "GRIB1"
  out_file = "/scratch/vsharma/for_wrf/test_<YYYYMMDDHH:2019030600>.grib1"
  out_regrid_target = "geolatlon,4000000,43000000,12000000,49000000,10000,10000"
  out_regrid_method="next_neighbour,square,2.0"
  tstart = 0, tstop = 600, tincr = 1 /
&Process in_field = "HSURF" /
&Process in_field = "HFL" /

!---------------------------------------------------------------------------------------
! Define input and output characteristics:
!---------------------------------------------------------------------------------------
&Process
  in_regrid_all = .true.
  in_file = "/scratch/lbraud/COSMO-1/ANA1819/laf<YYYYMMDDHH:2019030600>"
  in_regrid_target = "masspoint"
  in_regrid_method = "average,square,0.9"
  
  out_type = "GRIB1"
  out_file = "/scratch/vsharma/for_wrf/test_<YYYYMMDDHH:2019030600>.grib1"
  
  out_regrid_target = "geolatlon,4000000,43000000,12000000,49000000,10000,10000"
  
  out_regrid_method="next_neighbour,square,2.0"
  tstart = 0, tstop = 600, tincr = 1 /

!---------------------------------------------------------------------------------------
! Define fields to extract, define which fields to regrid right after the extraction,
! define operations to apply to extracted fields:
! The horizontal wind components have to be re-gridded to the model base grid before
! they can be transformed from the native to the geographical reference system with the
! help of the point operator 'n2geog'.
! The temperature fields can be extracted without any transformations.
!---------------------------------------------------------------------------------------


&Process in_field = "U",   regrid = .t., poper='n2geog', /!levmin = 1, levmax = 60/
&Process in_field = "V",   regrid = .t., poper='n2geog', /!levmin = 1, levmax = 60 /
&Process in_field = "T",   regrid = .t., /!levmin = 1, levmax = 80 /
&Process in_field = "P",                                 /!levmin = 1, levmax = 60 /
&Process in_field = "QV",                                /!levmin = 1, levmax = 60 /
&Process in_field = "T_SO" /
&Process in_field = "W_SO" /

&Process in_field = "QC"/
&Process in_field = "QR"/
&Process in_field = "QS"/
&Process in_field = "QG"/
&Process in_field = "QI"/

&Process in_field="PS"/
&Process in_field="PMSL"/
&Process in_field="T_2M", tag="T_2M" /
&Process in_field="TD_2M", tag="TD_2M"/
&Process in_field="T_G"/
&Process in_field="U_10M", regrid = .t., poper='n2geog' /
&Process in_field="V_10M",regrid = .t., poper='n2geog' /
&Process in_field="W_SNOW"/
&Process in_field="RHO_SNOW"/

!! NOW FOR TEMP FIELDS

&Process tmp1_field = "P" /
&Process tmp1_field = "HFL" /
&Process tmp1_field = "U", voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "V", voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "T", voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "FI", voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "RELHUM", voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "QC", voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /

&Process tmp1_field = "QR",voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "QS",voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "QG",voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /
&Process tmp1_field = "QI",voper="intpl_k2p,lnp",
                      voper_lev=50,65,75,85,100,110,125,140,150,165,175,185,200,210,225,240,250,275,285,300,325,350,365,385,400,430,450,
                                485,500,540,565,600,620,650,675,700,725,750,775,800,825,850,875,900,925,950 /

&Process tmp1_field = "T_SO" /
&Process tmp1_field = "W_SO" /

&Process tmp1_field="PS"/
&Process tmp1_field="PMSL"/
&Process tmp1_field="T_2M"/
&Process tmp1_field="TD_2M"/
&Process tmp1_field="T_G"/
&Process tmp1_field="U_10M"/
&Process tmp1_field="V_10M"/
&Process tmp1_field="W_SNOW"/
&Process tmp1_field="RHO_SNOW"/
&Process tmp1_field= "HSURF"/


! Define fields to copy from previous iteration, define derived fields:
! All fields available in the final iteration are re-gridded to the geographical 
! lat/lon grid before output, using nearest neighbour interpolation.
!---------------------------------------------------------------------------------------
&Process out_field = "PS" /
&Process out_field = "PMSL" /
&Process out_field = "T_2M" /
&Process out_field = "RELHUM_2M", tag = "RH_2M_H", use_tag = "T_2M, TD_2M" /
&Process out_field = "T_G" /
&Process out_field = "U_10M" /
&Process out_field = "V_10M" /
&Process out_field = "H_SNOW"/
&Process out_field = "RHO_SNOW" /
&Process out_field = "W_SNOW" /

&Process out_field = "U",      hoper="fill_undef,33,1." /
&Process out_field = "V",      hoper="fill_undef,33,1." /
&Process out_field = "T",      hoper="fill_undef,33,1." /
&Process out_field = "FI",     hoper="fill_undef,33,1." /
&Process out_field = "RELHUM", hoper="fill_undef,33,1." /
&Process out_field = "T_SO",   hoper="fill_undef,33,1." /
&Process out_field = "W_SO",   hoper="fill_undef,33,1." /
&Process out_field = "QC",   hoper="fill_undef,33,1." /
&Process out_field = "QR",   hoper="fill_undef,33,1." /
&Process out_field = "QS",   hoper="fill_undef,33,1." /
&Process out_field = "QG",   hoper="fill_undef,33,1." /
&Process out_field = "QI",   hoper="fill_undef,33,1." /
&Process out_field = "HSURF" /

