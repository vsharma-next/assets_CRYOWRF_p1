for file in test_*.grib1
do
    echo $file
    # EDITING the incoming grib file for cloud ice QI 
    grib_set -s indicatorOfParameter=178 -w table2Version=201,indicatorOfParameter=33 $file temp
    mv temp $file

    # TO BE DONE !
    grib_set -s indicatorOfParameter=85 -w indicatorOfParameter=197 $file temp
    mv temp $file

    # TO BE DONE !
    grib_set -s indicatorOfParameter=86 -w indicatorOfParameter=198 $file temp
    mv temp $file

    grib_copy -w level!=486,level!=1458 $file temp
    mv temp $file

    # TO change grib level indicator for soil temperature / moisture
    grib_set -s indicatorOfTypeOfLevel=112 -w indicatorOfTypeOfLevel=111 $file temp
    mv temp $file

    grib_set -s topLevel=0 -w bottomLevel=1,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s topLevel=1 -w topLevel=2,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s bottomLevel=3 -w bottomLevel=2,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s topLevel=3 -w topLevel=6,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s bottomLevel=9 -w bottomLevel=6,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s topLevel=9 -w topLevel=18,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s bottomLevel=27 -w bottomLevel=18,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s topLevel=27 -w topLevel=54,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s bottomLevel=81 -w bottomLevel=54,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s topLevel=81 -w topLevel=162,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

    grib_set -s bottomLevel=243 -w bottomLevel=162,indicatorOfTypeOfLevel=112 $file temp
    mv temp $file

done 
