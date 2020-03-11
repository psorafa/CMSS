#!/bin/bash
set -e

TARGETPATH=${1}

scripts/sh/util/mergeJson.sh "scripts/apex/importAssets.apex" "data/tree/assets.json" "{0}" "$TARGETPATH"