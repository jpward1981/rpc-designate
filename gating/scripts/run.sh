#!/usr/bin/env bash
# Copyright 2014-2018 , Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Shell Opts ----------------------------------------------------------------
set -xeuo pipefail

## Vars and Functions --------------------------------------------------------
source ${PWD}/gating/scripts/vars.sh
source ${PWD}/gating/scripts/functions.sh

## Main ----------------------------------------------------------------------
echo "Gate job started"
echo "+-------------------- START ENV VARS --------------------+"
env
echo "+-------------------- START ENV VARS --------------------+"

# Run tests
echo "RUN DESIGNATE. TESTS"
openstack-ansible ${MY_BASE_DIR}/gating/scripts/test_designate.yml \
                  -e working_dir=${MY_BASE_DIR} \
                  -e rpc_release=${RPC_RELEASE} \
                  ${ANSIBLE_PARAMETERS}

echo "Gate job ended"