FROM base/archlinux

# Solely for an optional vi mode
ARG host_user=defaultuser
ENV HOST_USER=${host_user}

# Update the system
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base base-devel

# Create test user
RUN useradd --create-home test && \
    echo "test ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add PKGBUILD
RUN mkdir /app
WORKDIR /app
ADD ./PKGBUILD /app
RUN chown -R test:test /app

# Now running as a non-privileged user
USER test:test

# Push an entrypoint
ADD ./entrypoint.sh /tmp/entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh"]
