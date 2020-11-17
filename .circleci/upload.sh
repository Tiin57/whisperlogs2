#!/bin/bash

set -e

ADDON_VERSION="$CIRCLE_TAG"

function get-toc-field() {
  local field_name="$1"
  if [ "$field_name" == "" ]; then
    echo "Usage: get-toc-field <field-name>"
    exit 1
  fi
  local value_str=$(cat ./WhisperLogs2.toc | grep "## $field_name:")
  if [ "$value_str" == "" ]; then
    echo "Field $field_name not found"
    exit 1
  fi
  echo ${value_str#*: } # split by ": ", get second token of result
}

INTERFACE_VERSION=$(get-toc-field Interface)
echo "INTERFACE_VERSION: $INTERFACE_VERSION"

WOW_VERSION=$(curl -s https://www.townlong-yak.com/framexml/builds |
  pup '#buildtable tbody tr json{}' |
  jq -r "map(select(.children[] | .text == \"$INTERFACE_VERSION\")) | .[0].children[0].children[0].text | split(\".\") | .[0:-1] | join(\".\")"
)
echo "WOW_VERSION: $WOW_VERSION"
CURSE_VERSION_ID=$(curl -s "https://wow.curseforge.com/api/game/versions?token=$CURSE_TOKEN" |
  jq -r ".[] | select(.name == \"$WOW_VERSION\") | .id"
)
echo "CURSE_VERSION_ID: $CURSE_VERSION_ID"

METADATA_BLOB=$(echo '{
  "changelog": "",
  "changelogType": "text",
  "releaseType": "alpha"
}' | jq ".displayName = \"$ADDON_VERSION\" | .gameVersions = [$CURSE_VERSION_ID]")

echo "METADATA_BLOB: $METADATA_BLOB"

cp WhisperLogs2.zip "WhisperLogs2-$ADDON_VERSION.zip"

curl \
  -F "file=@./WhisperLogs2-$ADDON_VERSION.zip" \
  -F "metadata=$METADATA_BLOB" \
  "https://wow.curseforge.com/api/projects/$CURSE_PROJECT_ID/upload-file?token=$CURSE_TOKEN"
