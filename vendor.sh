#!/bin/bash
set -e

SPEC_FILE=$1

if [ -z "$SPEC_FILE" ]; then
    echo "Usage: $0 <path_to_spec_file>"
    exit 1
fi

# 1. Extract Name and Version from the spec file
NAME=$(rpmspec -q --qf "%{name}\n" "$SPEC_FILE" | head -n1)
VERSION=$(rpmspec -q --qf "%{version}\n" "$SPEC_FILE" | head -n1)
SOURCE_DIR="${NAME}-${VERSION}"
VENDOR_TARBALL="${NAME}-${VERSION}-vendor.tar.xz"

echo "Processing: $NAME version $VERSION"

# 2. Download sources defined in the spec
spectool -g "$SPEC_FILE"

# 3. Unpack the primary source
# Assumes Source0 is the standard .crate or .tar.gz named %{name}-%{version}
if [ -f "${SOURCE_DIR}.crate" ]; then
    tar -xzvf "${SOURCE_DIR}.crate"
elif [ -f "${SOURCE_DIR}.tar.gz" ]; then
    tar -xzvf "${SOURCE_DIR}.tar.gz"
else
    echo "Error: Could not find source tarball for ${SOURCE_DIR}"
    exit 1
fi

# 4. Vendor dependencies
pushd "$SOURCE_DIR"
    echo "Running cargo vendor..."
    # We create the vendor dir and capture the config output
    mkdir -p .cargo
    cargo vendor > .cargo/config.toml
    
    # 5. Compress into the target format
    echo "Creating vendor tarball: $VENDOR_TARBALL"
    tar -cvJf "../$VENDOR_TARBALL" vendor/ .cargo/config.toml
popd

# 6. Cleanup
rm -rf "$SOURCE_DIR"

echo "--------------------------------------------------"
echo "Done! Created $VENDOR_TARBALL"
