#!/bin/sh



if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


touch /bin/updatePip



chmod +x /bin/updatePip


echo "#!/bin/sh" >> /bin/updatePip
local_dir=$(pwd)
echo "" >> /bin/updatePip
echo "" >> /bin/updatePip
echo "" >> /bin/updatePip
echo "" >> /bin/updatePip
echo "" >> /bin/updatePip
echo "sh $local_dir/update.sh" >> /bin/updatePip