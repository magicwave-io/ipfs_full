PP_ENV=stage
if [[ "${PP_ENV}" = "stage" ]]; then
    bootstrapServer="13.95.67.71"
   
fi
if [[ "${PP_ENV}" = "prod" ]]; then
    bootstrapServer="40.68.195.206"
   
fi
ssh edikk202@${bootstrapServer}

