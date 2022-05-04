FROM opensearchproject/opensearch-dashboards:1.2.0

LABEL maintainer="Santiago Dueñas <sduenas@bitergia.com>"
LABEL org.opencontainers.image.title="Bitergia Analytics OpenSearch Dashboards"
LABEL org.opencontainers.image.description="Bitergia Analytics OpenSearch Dashboards service"
LABEL org.opencontainers.image.url="https://bitergia.com/"
LABEL org.opencontainers.image.documentation="https://github.com/bitergia/bitergia-analytics-opensearch-dashboards/"
LABEL org.opencontainers.image.vendor="Bitergia"
LABEL org.opencontainers.image.authors="sduenas@bitergia.com"

#
# Setup
#

WORKDIR /usr/share/opensearch-dashboards

ENV PATH=/usr/share/opensearch-dashboards/bin:$PATH

#
# Plugins installation & configuration
#

# Install visualization plugins
RUN opensearch-dashboards-plugin install "https://github.com/dlumbrer/kbn_radar/releases/download/osd-1.2.0/kbn_radar-7.10.0_1.2.0.zip" && \
    opensearch-dashboards-plugin install "https://github.com/dlumbrer/kbn_network/releases/download/osd-1.2.0/kbn_network-7.10.0_1.2.0.zip" && \
    opensearch-dashboards-plugin install "https://github.com/dlumbrer/kbn_dotplot/releases/download/osd-1.2.0/kbn_dotplot-7.10.0_1.2.0.zip" && \
    opensearch-dashboards-plugin install "https:/github.com/dlumbrer/kbn_polar/releases/download/osd-1.2.0/kbn_polar-1.0.0_1.2.0.zip"

# FIXME: This is a temporary fork because OSD is 
# not supported upstream.
RUN opensearch-dashboards-plugin install "https://github.com/Bitergia/kibana-enhanced-table/releases/download/osd-1.2.0/enhanced-table-1.11.0_1.2.0.zip"

# Install Bitergia Analytics plugins
RUN opensearch-dashboards-plugin install "https://github.com/Bitergia/bitergia-analytics-plugin/releases/download/0.0.7/bitergia_analytics-0.0.7_1.2.0.zip"

# Remove plugins not supported on this release
RUN opensearch-dashboards-plugin remove alertingDashboards && \
    opensearch-dashboards-plugin remove anomalyDetectionDashboards && \
    opensearch-dashboards-plugin remove observabilityDashboards && \
    opensearch-dashboards-plugin remove queryWorkbenchDashboards && \
    opensearch-dashboards-plugin remove reportsDashboards

#
# Default configuration
#

COPY opensearch_dashboards.yml config/
