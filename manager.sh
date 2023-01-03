#!/bin/sh

if [ "$(id -u)" != "0" ]; 
then
   echo "This script must be run as root" 1>&2
   exit 1
fi

clear
echo "Do you want to install or remove the service?"
echo "1. Install"
echo "2. Remove"
read -p "Enter your choice [1-2]: " choice

case $choice 
in
   1) echo "Installing....."
      touch /bin/updatePip
      chmod +x /bin/updatePip
      echo "#!/bin/bash" >> /bin/updatePip
      local_dir=$(pwd)
      for i in {1..4} 
         do
            echo "" >> /bin/updatePip
         done
      echo "clear" >> /bin/updatePip
      echo "bash $local_dir/update.sh" >> /bin/updatePip ;;
   2) echo "Removing....."
      rm -rf /bin/updatePip requirements.txt ;;
   *) echo "Invalid choice";;
esac



echo "Done."