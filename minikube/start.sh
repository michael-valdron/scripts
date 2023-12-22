#!/bin/sh

MINIKUBE_CMD=${MINIKUBE_CMD:-'minikube'}
MINIKUBE_CPUS=${MINIKUBE_CPUS:-'6'}
MINIKUBE_MEM=${MINIKUBE_MEM:-'9216m'}
MINIKUBE_DRIVER=${MINIKUBE_DRIVER:-'kvm2'}
MINIKUBE_ADMIN=${MINIKUBE_ADMIN:-'admin-user'}
KUBECTL_CMD=${KUBECTL_CMD:-'kubectl'}

proxy_pid_file=~/.minikube/proxy.pid

if [ ! "$(command -v ${MINIKUBE_CMD})" ]
then
    echo "command \"${MINIKUBE_CMD}\" does not exist on this system"
    exit 1
fi

if [ ! "$(command -v ${KUBECTL_CMD})" ]
then
    echo "command \"${KUBECTL_CMD}\" does not exist on this system"
    exit 1
fi

${MINIKUBE_CMD} start --cpus=${MINIKUBE_CPUS} --memory=${MINIKUBE_MEM} --driver=${MINIKUBE_DRIVER} --addons='ingress' $@ && \
${KUBECTL_CMD} apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml && \
cat <<EOF | ${KUBECTL_CMD} apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${MINIKUBE_ADMIN}
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${MINIKUBE_ADMIN}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: ${MINIKUBE_ADMIN}
    namespace: kubernetes-dashboard
EOF

if [ $? -eq 0 ]
then
    user_token=$(${KUBECTL_CMD} -n kubernetes-dashboard create token ${MINIKUBE_ADMIN})
    ${KUBECTL_CMD} proxy > /dev/null &
    echo $! > ${proxy_pid_file}
    echo 'Dashboard URL: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/'
    echo "User token: ${user_token}"
fi
