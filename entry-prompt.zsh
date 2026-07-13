# Ensure permissions are correct for the mounted config volume
# This fixes "Permission denied" on the host for ./lazypi_config
bash /home/dev/setup-permissions.sh

# Welcome banner
echo "\n\033[1;34m===================================================="
echo "  Welcome to the LazyPi Development Container!  "
echo "====================================================\033[0m"

# Prompt the user to update LazyPi on shell start
echo -n "Would you like to check for LazyPi package updates? (Y/n): "
read response
echo ""
if [[ "$response" == "y" || "$response" == "Y" || "$response" == "" ]]; then
    echo "Updating LazyPi packages..."
    npx @robzolkos/lazypi
    echo "Update check complete."
else
    echo "Skipping updates."
fi
echo -e "\033[1;34m----------------------------------------------------\033[0m\n"
