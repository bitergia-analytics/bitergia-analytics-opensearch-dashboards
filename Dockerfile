# Copyright (C) Bitergia
# GPLv3 License

FROM opensearchproject/opensearch-dashboards:2.7.0

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
RUN opensearch-dashboards-plugin install "https://github.com/dlumbrer/kbn_radar/releases/download/osd-2.7.0/kbn_radar-7.10.0_2.7.0.zip"
RUN opensearch-dashboards-plugin install "https://github.com/dlumbrer/kbn_network/releases/download/osd-2.7.0/kbn_network-7.10.0_2.7.0.zip"
RUN opensearch-dashboards-plugin install "https://github.com/dlumbrer/kbn_dotplot/releases/download/osd-2.7.0/kbn_dotplot-7.10.0_2.7.0.zip"
RUN opensearch-dashboards-plugin install "https:/github.com/dlumbrer/kbn_polar/releases/download/osd-2.7.0/kbn_polar-1.0.0_2.7.0.zip"

# Install enhanced table plugin
RUN opensearch-dashboards-plugin install "https://github.com/fbaligand/kibana-enhanced-table/releases/download/v1.13.3/enhanced-table-1.13.3_osd-2.7.0.zip"

# Install Bitergia Analytics plugins
RUN opensearch-dashboards-plugin install "https://github.com/bitergia-analytics/bitergia-analytics-plugin/releases/download/0.14.0/bitergia_analytics-0.14.0_2.7.0.zip"

# Remove plugins not supported on this release
RUN opensearch-dashboards-plugin remove reportsDashboards

#
# Default configuration
#

COPY opensearch_dashboards.yml config/
