ARG VARIANT=9.0-bookworm-slim@sha256:35048e3a81e6a07c316e7bbbd80d80d2ba705fe5f23a8ed42b6638c8f4c20d30
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT}
ENV PATH $PATH:/home/vscode/.dotnet:/home/vscode/.dotnet/tools

RUN chmod -R a+w /usr/share/dotnet

ARG VARIANT
RUN if [ "${VARIANT#*noble}" != "$VARIANT"  ]; then \
    if id "ubuntu" &>/dev/null; then \
    echo "Deleting user 'ubuntu'  for $VARIANT" && userdel -f -r ubuntu || echo "Failed to delete ubuntu user for $VARIANT"; \
    else \
    echo "User 'ubuntu' does not exist for $VARIANT"; \ 
    fi; \
    fi

# clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# see https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=