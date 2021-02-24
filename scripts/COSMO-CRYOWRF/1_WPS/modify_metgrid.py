#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 16 14:55:28 2021

@author: varun
"""

import xarray as xr
import numpy as np
import glob
from multiprocessing import Pool

def modify_metgrid_files(filename):

    ds = xr.open_dataset(filename);
    
    # MODIFY RH
    var='RH'
    temp = ds[var]
    temp[0,1:4,:,:] = np.nan
    temp = temp.interpolate_na(dim="num_metgrid_levels")
    ds[var] = temp
    
    ## MODIFY UU
    var='UU'
    temp = ds[var]
    temp[0,1:4,:,:] = np.nan
    temp = temp.interpolate_na(dim="num_metgrid_levels")
    ds[var] = temp
    
    ## MODIFY VV
    var='VV'
    temp = ds[var]
    temp[0,1:4,:,:] = np.nan
    temp = temp.interpolate_na(dim="num_metgrid_levels")
    ds[var] = temp
    
    ## MODIFY TT
    var='TT'
    temp = ds[var]
    temp[0,1:4,:,:] = np.nan
    temp = temp.interpolate_na(dim="num_metgrid_levels")
    ds[var] = temp

    ds.to_netcdf(path='./mod_files/'+filename)
    ds.close()

files = sorted(glob.glob('./met_em*'))
    
p = Pool(6)
p.map(modify_metgrid_files,files)



# # MODIFY RH
# var='RH'
# temp_min = 0.0
# temp_max = 100.0
# temp = ds[var]
# temp=temp.where((temp <= temp_max) & (temp>=temp_min))
# temp = temp.interpolate_na(dim="num_metgrid_levels")
# ds[var] = temp

# ## MODIFY UU
# var='UU'
# temp_min = -50.0
# temp_max = 50.0
# temp = ds[var]
# temp=temp.where((temp <= temp_max) & (temp>=temp_min))
# temp = temp.interpolate_na(dim="num_metgrid_levels")
# ds[var] = temp

# ## MODIFY VV
# var='VV'
# temp_min = -50.0
# temp_max = 50.0
# temp = ds[var]
# temp=temp.where((temp <= temp_max) & (temp>=temp_min))
# temp = temp.interpolate_na(dim="num_metgrid_levels")
# ds[var] = temp

# ## MODIFY TT
# var='TT'
# temp_min = 150.0
# temp_max = 320.0
# temp = ds[var]
# temp=temp.where((temp <= temp_max) & (temp>=temp_min))
# temp = temp.interpolate_na(dim="num_metgrid_levels")
# #ds[var] = temp
