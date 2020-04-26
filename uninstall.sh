#!/bin/bash

function cleanup_cluster() {
  FOLDER="/${VSPHERE_DATACENTER}/vm/${VSPHERE_FOLDER}"
  echo "cleaning up bootstrap vm"
  binaries/govc vm.destroy /${FOLDER}/${OPENSHIFT_CLUSTERNAME}-bootstrap-1
  echo "cleaning up master vms"
  for i in $(eval echo {1..${MASTER_COUNT}}); do
    binaries/govc vm.destroy /${FOLDER}/${OPENSHIFT_CLUSTERNAME}-master-$i
  done
  echo "cleaning up worker vms"
  for i in $(eval echo {1..${WORKER_COUNT}}); do
    binaries/govc vm.destroy /${FOLDER}/${OPENSHIFT_CLUSTERNAME}-worker-$i
  done
  echo "cleaning install files/folders"
  rm -rf binaries iso ${OPENSHIFT_CLUSTERNAME} /tmp/tmpocpiso /tmp/temp_isolinux.cfg
  sudo rm -rf /var/www/html/tramali
  rm ~/.ssh/id_rsa*
}

source ./environment.properties

export GOVC_URL=${VSPHERE_HOSTNAME}
export GOVC_USERNAME=${VSPHERE_USERNAME}
export GOVC_PASSWORD=${VSPHERE_PASSWORD}
export GOVC_INSECURE=${VSPHERE_INSECURE}
export GOVC_DATASTORE=${VSPHERE_IMAGE_DATASTORE}

cleanup_cluster
