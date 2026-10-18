ARG VARIANT=9.0-bookworm-slim@sha256:2f5eb32870b4c0074a3d5b5191a03553bcab7b74463a76a7c0a5f3ef65c90fe5
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