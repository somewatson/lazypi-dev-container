# Prompt the user to update LazyPi on shell start
echo "\n--- LazyPi Dev Container ---"
echo "Would you like to check for LazyPi package updates? (y/N)"
read -k 1 response
echo ""
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    echo "Updating LazyPi packages..."
    npx @robzolkos/lazypi
    echo "Update check complete."
else
    echo "Skipping updates."
fi
echo "---------------------------\n"
