KUBE_RELEASE?=1.2.0
MESOS_IMAGE_REPO?=melan/kubernetes-mesos
BUILD_IMAGE_REPO?=melan/build-mesos-docker

clone:
	git clone git@github.com:kubernetes/kubernetes.git

clean:
	rm -rf kubernetes

build: pull-docker-build-image
	cd kubernetes; git checkout ${KUBE_RELEASE}
	docker run \
		--name "build-k8s-${KUBERNETES_CONTRIB}" \
		--rm \
		-v `pwd`/kubernetes:/src/kubernetes \
		-e KUBERNETES_CONTRIB="${KUBERNETES_CONTRIB}" \
		${BUILD_IMAGE_REPO} \
		/bin/bash -c "cd /src/kubernetes; make"

package-mesos:
	cd ./kubernetes/cluster/mesos/docker/km; IMAGE_REPO=${MESOS_IMAGE_REPO} ./build.sh

push-mesos:
	docker push ${MESOS_IMAGE_REPO}

create-docker-build-image:
	docker build -t ${BUILD_IMAGE_REPO} .

push-docker-build-image:
	docker push ${BUILD_IMAGE_REPO}

pull-docker-build-image:
	docker pull ${BUILD_IMAGE_REPO}