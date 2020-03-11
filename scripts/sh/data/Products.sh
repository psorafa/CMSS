#!/bin/bash
set -e

TARGETPATH=${1}

scripts/sh/util/mergeJson.sh "scripts/apex/importProducts.apex" "data/tree/products.json" "{0}" "$TARGETPATH"



