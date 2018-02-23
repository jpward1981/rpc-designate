#!/usr/bin/env bash
# Copyright 2014-2017 , Rackspace US, Inc.
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

## Vars ----------------------------------------------------------------------
source ${PWD}/gating/scripts/vars.sh

## Main ----------------------------------------------------------------------
echo "Pre gate job started"
echo "+-------------------- START ENV VARS --------------------+"
env
echo "+-------------------- START ENV VARS --------------------+"

# Setup a few variables specific to the scenario that we are running
case $RE_JOB_SCENARIO in
"newton")
  # Pin RPC-Release to 14.3 for newton
  export RPC_RELEASE="r14.3.0"
  export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
  export OSA_BASE_DIR=${OS_BASE_DIR}/openstack-ansible

  ;;
"pike")
  # Pin RPC-Release to 16.0 for pike
  export RPC_RELEASE="r16.0.0"
  export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
  export OSA_BASE_DIR=/opt/openstack-ansible
  ;;
esac

# Clone rpc-openstack
if [ ! -d ${OS_BASE_DIR} ]; then
  git clone --recursive -b ${RPC_RELEASE} https://github.com/rcbops/rpc-openstack ${OS_BASE_DIR}
fi
 
if [ ${RPC_PRODUCT_RELEASE} == "newton"]; then 
  echo "python-ldap==2.5.2" >> ${OSA_BASE_DIR}/global-requirement-pins.txt
  echo "Flask!=0.11,<1.0,>=0.10" >> ${OSA_BASE_DIR}/global-requirement-pins.txt
fi

# Make sure that we are in the base dir and deploy openstack aio
cd ${OS_BASE_DIR}
${OS_BASE_DIR}/scripts/deploy.sh
# Setup ansible for the environment
#scripts/bootstrap-ansible.sh

# Setup the aio environment
#scripts/bootstrap-aio.sh

#cd ${OS_BASE_DIR}/openstack-ansible
# Configure Host for openstack
#openstack-ansible playbooks/setup-hosts.yml

# Configure Infrastructure for Openstack
#openstack-ansible playbooks/setup-infrastructure.yml

# Keystone is the only openstack service that we need installed
#openstack-ansible playbooks/os-keystone-install.yml

# Install Designate
cd ${MY_BASE_DIR}
${MY_BASE_DIR}/scripts/deploy.sh

# We may need this later, right now I don't run any tempest tests
# install tempest
#cd ${OS_BASE_DIR}/openstack-ansible/playbooks/
#openstack-ansible  ${OS_BASE_DIR}/openstack-ansible/playbooks/os-tempest-install.yml

echo "Pre gate job ended"
