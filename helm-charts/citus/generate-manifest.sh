#!/usr/bin/env bash

helm template citus-dev ./ \
  --values values.yaml \
  --namespace usdf-ppdb-dev > generated-citus-manifest.yaml