#!/bin/sh



if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi






# Ask the user if he wants to install or remove the service
echo "Do you want to install or remove the service?"
echo "1. Install"
echo "2. Remove"
read -p "Enter your choice [1-2]: " choice
# Make sure the choice is valid



case $choice in
   1) echo "You chose to install"
      touch /bin/updatePip
      chmod +x /bin/updatePip
      echo "#!/bin/sh" >> /bin/updatePip
      local_dir=$(pwd)
      echo "" >> /bin/updatePip
      echo "" >> /bin/updatePip
      echo "" >> /bin/updatePip
      echo "" >> /bin/updatePip
      echo "" >> /bin/updatePip
      echo "sh $local_dir/update.sh" >> /bin/updatePip;;
   2) echo "You chose to remove"
      rm -rf /bin/updatePip ;;
   *) echo "Invalid choice";;
esac