#!/bin/bash
# scripts/setup-providers.sh
# Generate providers.tf files from templates using variables from terraform.auto.tfvars

set -e

# Check if terraform.auto.tfvars exists
if [ ! -f "00-tfstate/terraform.auto.tfvars" ]; then
    echo "Error: 00-tfstate/terraform.auto.tfvars not found!"
    echo "Please create this file with your bucket_prefix and project values."
    exit 1
fi

# Read variables from terraform.auto.tfvars
BUCKET_PREFIX=$(grep 'bucket_prefix' 00-tfstate/terraform.auto.tfvars | cut -d'"' -f2)
PROJECT=$(grep 'project' 00-tfstate/terraform.auto.tfvars | cut -d'"' -f2)
LOCATION=$(grep 'location' 00-tfstate/terraform.auto.tfvars | cut -d'"' -f2)
MINIO_DOMAIN=$(grep 'minio_domain' 00-tfstate/terraform.auto.tfvars | cut -d'"' -f2)

# Check if variables were found
if [ -z "$BUCKET_PREFIX" ] || [ -z "$PROJECT" ] || [ -z "$LOCATION" ] || [ -z "$MINIO_DOMAIN" ]; then
    echo "Error: Could not find all required variables in 00-tfstate/terraform.auto.tfvars"
    echo "Make sure the file contains:"
    echo '  bucket_prefix = "your-prefix"'
    echo '  project       = "your-project"'
    echo '  location      = "nbg1"'
    echo '  minio_domain  = "your-objectstorage.com"'
    exit 1
fi

echo "Using configuration:"
echo "  Bucket name: $BUCKET_PREFIX-$PROJECT-tfstate"
echo "  S3 endpoint: https://$LOCATION.$MINIO_DOMAIN"

# Generate providers.tf from templates
find . -name "providers.tf.template" -exec sh -c '
  sed -e "s/BUCKET_PREFIX-PROJECT-tfstate/'$BUCKET_PREFIX'-'$PROJECT'-tfstate/g" \
      -e "s|https://LOCATION.MINIO_DOMAIN|https://'$LOCATION'.'$MINIO_DOMAIN'|g" \
      "$1" > "${1%.template}"
  echo "Generated: ${1%.template}"
' _ {} \;

echo "✅ All providers.tf files generated successfully!"
echo "You can now run terraform commands in each directory." 