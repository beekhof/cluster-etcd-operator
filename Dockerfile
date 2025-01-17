FROM registry.svc.ci.openshift.org/openshift/release:golang-1.12 AS builder
WORKDIR /go/src/github.com/openshift/cluster-etcd-operator
COPY . .
RUN go build ./cmd/cluster-etcd-operator

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/cluster-etcd-operator/cluster-etcd-operator /usr/bin/
#LABEL io.openshift.release.operator true
