#!/bin/sh

set -e

# Login
az login --service-principal --username ${AZURE_CLIENT_ID} --password ${AZURE_SECRET} --tenant ${AZURE_TENANT_ID}

# Set subscription id
az account set --subscription ${AZURE_SUBSCRIPTION_ID}

# Enable Static Website
if [ -z "$AZURE_ERROR_DOCUMENT_NAME" ]; then
    az storage blob service-properties update --account-name ${AZURE_STORAGE_ACCOUNT_NAME} --static-website --index-document ${AZURE_INDEX_DOCUMENT_NAME}
else
    az storage blob service-properties update --account-name ${AZURE_STORAGE_ACCOUNT_NAME} --static-website --404-document ${AZURE_ERROR_DOCUMENT_NAME} --index-document ${AZURE_INDEX_DOCUMENT_NAME}
fi

# Upload source to storage
az storage blob upload-batch -s ${SOURCE_DIR} -d \$web --account-name ${AZURE_STORAGE_ACCOUNT_NAME}
