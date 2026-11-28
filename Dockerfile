# syntax=docker/dockerfile:1

# Supports multi-architecture builds (linux/arm64 for Oracle Ampere & linux/amd64)
ARG ERPNEXT_VERSION=develop
FROM frappe/erpnext:${ERPNEXT_VERSION}

# Arguments for dependency apps and custom repo
ARG HEALTH_REPO=https://github.com/earthians/marley
ARG HEALTH_BRANCH=develop
ARG OPD_REPO=https://github.com/nareshvjn/opd_clinic_1
ARG OPD_BRANCH=main

USER root
# Install procps (provides `ps` command required by Frappe after_migrate flow-server hook)
RUN apt-get update && apt-get install -y --no-install-recommends procps && rm -rf /var/lib/apt/lists/*

USER frappe
WORKDIR /home/frappe/frappe-bench

# Install Healthcare app dependency (earthians/marley) without compiling frontend assets during image build
RUN bench get-app --branch ${HEALTH_BRANCH} --skip-assets ${HEALTH_REPO}

# Get and install opd_clinic_1 directly from GitHub
RUN bench get-app --branch ${OPD_BRANCH} --skip-assets ${OPD_REPO}
