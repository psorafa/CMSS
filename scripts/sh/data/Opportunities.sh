#!/bin/bash
set -e

TARGETPATH=${1}

scripts/sh/util/mergeJson.sh "scripts/apex/importOpportunities.apex" "data/tree/opportunities.json" "{0}" "$TARGETPATH"



