#!/bin/bash

# Script to create a proper npm package tarball that includes package-lock.json
# This works around the npm pack issue with WSL/Windows cross-platform paths

set -e

PACKAGE_NAME="amazon-connect-chat-interface"
VERSION=$(grep '"version"' package.json | cut -d'"' -f4)
TARBALL_NAME="${PACKAGE_NAME}-${VERSION}.tgz"

echo "Creating package tarball: ${TARBALL_NAME}"

# Create a temporary directory for the package
TEMP_DIR=$(mktemp -d)
PACKAGE_DIR="${TEMP_DIR}/package"

echo "Temporary directory: ${TEMP_DIR}"

# Create package directory
mkdir -p "${PACKAGE_DIR}"

# Copy essential files based on the files field in package.json
echo "Copying files..."

# Core package files
cp package.json "${PACKAGE_DIR}/"
cp package-lock.json "${PACKAGE_DIR}/"
cp README.md "${PACKAGE_DIR}/"
cp LICENSE "${PACKAGE_DIR}/"
cp .babelrc "${PACKAGE_DIR}/"
cp .eslintrc "${PACKAGE_DIR}/"
cp jsconfig.json "${PACKAGE_DIR}/"
cp global-setup.js "${PACKAGE_DIR}/"

# Copy directories
cp -r src "${PACKAGE_DIR}/"
cp -r configuration "${PACKAGE_DIR}/"
cp -r scripts "${PACKAGE_DIR}/"
cp -r local-testing "${PACKAGE_DIR}/"

# Copy build directory if it exists
if [ -d "build" ]; then
    cp -r build "${PACKAGE_DIR}/"
fi

# Create the tarball
echo "Creating tarball..."
cd "${TEMP_DIR}"
tar -czf "${TARBALL_NAME}" package/

# Move the tarball to the original directory
mv "${TARBALL_NAME}" "/home/iank/git_repos/amazon-connect-chat-interface/"

# Clean up
rm -rf "${TEMP_DIR}"

echo "Package created successfully: ${TARBALL_NAME}"
echo "Contents of the package:"
tar -tzf "/home/iank/git_repos/amazon-connect-chat-interface/${TARBALL_NAME}" | head -20
