echo "Oppretter Sandbox"
call sfdx force:org:create --type sandbox --definitionfile config/dev-sandbox-def.json -a %1 -s -w 240 -u NAV_PROD_SFDX

echo "Ferdig"


