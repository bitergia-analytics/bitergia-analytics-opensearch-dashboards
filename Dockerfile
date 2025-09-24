# Copyright (C) Bitergia
# GPLv3 License

FROM opensearchproject/opensearch-dashboards:3.2.0

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
RUN opensearch-dashboards-plugin install https://github.com/bitergia-analytics/radar-vis-plugin/releases/download/0.33.0/radar-vis-plugin-0.33.0_3.2.0.zip
RUN opensearch-dashboards-plugin install https://github.com/bitergia-analytics/network-vis-plugin/releases/download/0.33.0/network-vis-plugin-0.33.0_3.2.0.zip
RUN opensearch-dashboards-plugin install https://github.com/bitergia-analytics/dotplot-vis-plugin/releases/download/0.33.0/dotplot-vis-plugin-0.33.0_3.2.0.zip
RUN opensearch-dashboards-plugin install https://github.com/bitergia-analytics/polar-vis-plugin/releases/download/0.33.0/polar-vis-plugin-0.33.0_3.2.0.zip

# Install enhanced table plugin
RUN opensearch-dashboards-plugin install "https://github.com/fbaligand/kibana-enhanced-table/releases/download/v1.14.0/enhanced-table-1.14.0_osd-3.2.0.zip"

# Install Bitergia Analytics plugins
RUN opensearch-dashboards-plugin install https://github.com/bitergia-analytics/bitergia-analytics-plugin/releases/download/0.33.0/bitergia-analytics-plugin-0.33.0_3.2.0.zip

# Remove plugins not supported on this release
RUN opensearch-dashboards-plugin remove reportsDashboards

#
# Default configuration
#

COPY opensearch_dashboards.yml config/
