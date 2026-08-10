ARG VARIANT=9.0-bookworm-slim@sha256:2205fd3a7cf5e422c58398a9968aa8b5041fdbb47c76574fe631082e4cbfa2b8
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