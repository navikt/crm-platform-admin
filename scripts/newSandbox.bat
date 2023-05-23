echo "Oppretter Sandbox"
call sf org create sandbox --alias %1 --name %1 --license-type Developer --set-default --wait 240 --target-org NAV_PROD

echo "Ferdig"
