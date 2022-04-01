echo "Oppretter scratch org"
call sfdx force:org:create --type sandbox --definitionfile config/dev-sandbox-def.json -a %1 -s -w 120 -u NAV_PROD_SFDX

echo "Ferdig"


