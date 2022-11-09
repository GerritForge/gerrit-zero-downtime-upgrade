FROM gerritcodereview/gerrit:3.7.5

ENV GERRIT_BRANCH=stable-3.7

ENV GERRIT_CI_URL=https://gerrit-ci.gerritforge.com/job

USER root

RUN yum install -y iputils nmap curl lsof gettext net-tools sudo

USER gerrit

ADD --chown=gerrit:gerrit $GERRIT_CI_URL/plugin-javamelody-bazel-master-$GERRIT_BRANCH/lastSuccessfulBuild/artifact/bazel-bin/plugins/javamelody/javamelody.jar /var/gerrit/plugins/
ADD --chown=gerrit:gerrit $GERRIT_CI_URL/plugin-high-availability-bazel-$GERRIT_BRANCH/lastSuccessfulBuild/artifact/bazel-bin/plugins/high-availability/high-availability.jar /var/gerrit/plugins/
ADD --chown=gerrit:gerrit $GERRIT_CI_URL/plugin-healthcheck-bazel-$GERRIT_BRANCH/lastSuccessfulBuild/artifact/bazel-bin/plugins/healthcheck/healthcheck.jar /var/gerrit/plugins/
ADD --chown=gerrit:gerrit https://repo1.maven.org/maven2/com/gerritforge/global-refdb/3.6.6/global-refdb-3.6.6.jar /var/gerrit/lib/

USER root

ADD start.sh /bin/
ADD wait-for-it.sh /bin/

RUN rm -Rf /var/gerrit/{git,index,cache}/*

ARG GERRIT_UID=1000
RUN usermod -u ${GERRIT_UID} gerrit &> /dev/null

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/start.sh
