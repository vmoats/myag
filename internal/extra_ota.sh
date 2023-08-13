#!/bin/bash -e

# Make sure we're in the correct directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd $DIR

# Constants
# TODO: get these from package_ota.sh
OTA_DIR="$DIR/../output/ota"
TOOLS_DIR="$DIR/../tools"

AGNOS_UPDATE_URL=${AGNOS_UPDATE_URL:-https://commadist.azureedge.net/agnosupdate}
AGNOS_STAGING_UPDATE_URL=${AGNOS_STAGING_UPDATE_URL:-https://commadist.azureedge.net/agnosupdate-staging}
OTA_JSON="$OTA_DIR/ota.json"
OTA_STAGING_JSON="$OTA_DIR/ota-staging.json"
EXTRA_JSON="$OTA_DIR/extra.json"
EXTRA_STAGING_JSON="$OTA_DIR/extra-staging.json"

process_file() {
  local NAME=$1
  local HASH_RAW=$(cat $OTA_JSON | jq -r ".[] | select(.name == \"$NAME\") | .hash_raw")

  local FILE_NAME="$NAME-$HASH_RAW.img"

  local IMAGE_FILE="$OTA_DIR/$FILE_NAME"
  if [ ! -f $IMAGE_FILE ]; then
    local XZ_FILE="$IMAGE_FILE.xz"
    if [ ! -f "$XZ_FILE" ]; then
      local URL=$(cat $OTA_JSON | jq -r ".[] | select(.name == \"$NAME\") | .url")
      echo "Downloading $NAME..."
      wget -O $XZ_FILE $URL
    fi

    echo "Decompressing $NAME..."
    xz --decompress --stdout $XZ_FILE > $IMAGE_FILE
  fi

  local HASH=$(cat $OTA_JSON | jq -r ".[] | select(.name == \"$NAME\") | .hash")
  local ACTUAL_HASH=$(sha256sum $IMAGE_FILE | cut -c 1-64)
  if [ "$ACTUAL_HASH" != "$HASH" ]; then
    echo "$NAME hash mismatch!"
    echo "  Expected: $HASH"
    echo "  Actual:   $ACTUAL_HASH"
    exit 1
  else
    echo "$NAME hash verified"
  fi

  local SPARSE=$(cat $OTA_JSON | jq -r ".[] | select(.name == \"$NAME\") | .sparse")
  if [ $SPARSE == "true" ] && [ $NAME == "system" ]; then
    local OPTIMIZED_IMAGE_FILE=${IMAGE_FILE%.img}-optimized.img
    if [ ! -f "$OPTIMIZED_IMAGE_FILE" ]; then
      echo "Optimizing $NAME..."
      $TOOLS_DIR/simg2dontcare.py $IMAGE_FILE $OPTIMIZED_IMAGE_FILE
    fi
    IMAGE_FILE=$OPTIMIZED_IMAGE_FILE
  fi

  local GZ_FILE_NAME="$FILE_NAME.gz"
  local GZ_FILE="$OTA_DIR/$GZ_FILE_NAME"
  if [ ! -f "$GZ_FILE" ]; then
    echo "Compressing $NAME..."
    gzip -c $IMAGE_FILE > $GZ_FILE
  fi

  local SIZE=$(wc -c < $GZ_FILE)
  local FULL_CHECK=$(cat $OTA_JSON | jq -r ".[] | select(.name == \"$NAME\") | .full_check")
  local HAS_AB=$(cat $OTA_JSON | jq -r ".[] | select(.name == \"$NAME\") | .has_ab")
  cat <<EOF >> $EXTRA_JSON
  {
    "name": "$NAME",
    "url": "$AGNOS_UPDATE_URL/$GZ_FILE_NAME",
    "hash": "$HASH",
    "hash_raw": "$HASH_RAW",
    "size": $SIZE,
    "sparse": $SPARSE,
    "full_check": $FULL_CHECK,
    "has_ab": $HAS_AB
  },
EOF

  cat <<EOF >> $EXTRA_STAGING_JSON
  {
    "name": "$NAME",
    "url": "$AGNOS_STAGING_UPDATE_URL/$GZ_FILE_NAME",
    "hash": "$HASH",
    "hash_raw": "$HASH_RAW",
    "size": $SIZE,
    "sparse": $SPARSE,
    "full_check": $FULL_CHECK,
    "has_ab": $HAS_AB
  },
EOF
}

cd $ROOT

mkdir -p $OTA_DIR

echo "[" > $EXTRA_JSON
echo "[" > $EXTRA_STAGING_JSON

if [ ! -f $OTA_JSON ]; then
  echo "Downloading $OTA_JSON..."
  wget -O $OTA_JSON https://raw.githubusercontent.com/commaai/openpilot/master/system/hardware/tici/agnos.json
fi

for image in $(cat $OTA_JSON | jq -r '.[] | .name'); do
  process_file $image
done

# remove trailing comma
sed -i '$ s/.$//' $EXTRA_JSON
sed -i '$ s/.$//' $EXTRA_STAGING_JSON

echo "]" >> $EXTRA_JSON
echo "]" >> $EXTRA_STAGING_JSON

echo "Done!"
