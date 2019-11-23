#!/bin/bash
#put script in MalluOS source folder, make executable (chmod +x createupdate.sh) and run it (./createupdate.sh)

#modify values below
#leave blank if not used
maintainer="Name (nickname)" #ex: Mohammed Althaf (althafvly)
oem="OEM" #ex: Motorola
device="device codename" #ex: osprey
devicename="name of device" #ex: Moto G 2015
zip="MalluOS zip" #ex: MalluOS-1.2-Babu_Namboothiri-20200816-osprey-OFFICIAL.zip
buildtype="Beta" #choose from Testing/Alpha/Beta/Weekly/Monthly
forum="https://link"
gapps="https://link"
firmware="https://link"
modem="https://link"
bootloader="https://link"
recovery="https://link"
paypal="https://link"
telegram="https://link"

#don't modify from here
script_path="`dirname \"$0\"`"
zip_name=$script_path/out/target/product/$device/$zip
buildprop=$script_path/out/target/product/$device/system/build.prop

if [ -f $script_path/$device.json ]; then
  rm $script_path/$device.json
fi

linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
zip_only=`basename "$zip_name"`
md5=`md5sum "$zip_name" | cut -d' ' -f1`
size=`stat -c "%s" "$zip_name"`
version=`echo "$zip_only" | cut -d'-' -f2`
v_max=`echo "$version" | cut -d'.' -f1 | cut -d'-' -f2`
v_min=`echo "$version" | cut -d'.' -f2`
version=`echo $v_max.$v_min`

echo '{
  "response": [
    {
        "maintainer": "'$maintainer'",
        "oem": "'$oem'",
        "device": "'$devicename'",
        "filename": "'$zip_only'",
        "download": "https://sourceforge.net/projects/malluos/files/'$device'/'$zip_only'/download",
        "timestamp": '$timestamp',
        "md5": "'$md5'",
        "size": '$size',
        "version": "'$version'",
        "buildtype": "'$buildtype'",
        "forum": "'$forum'",
        "gapps": "'$gapps'",
        "firmware": "'$firmware'",
        "modem": "'$modem'",
        "bootloader": "'$bootloader'",
        "recovery": "'$recovery'",
        "paypal": "'$paypal'",
        "telegram": "'$telegram'"
    }
  ]
}' >> $device.json
