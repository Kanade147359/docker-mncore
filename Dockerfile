# Use Debian as the base image
FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    samba \
    cifs-utils \
    wget \
    xz-utils

# Create SMB user
# Create SMB user
RUN useradd -M -s /sbin/nologin myuser && \
    echo "myuser:mypassword" | chpasswd && \
    (echo "mypassword"; echo "mypassword") | smbpasswd -a myuser -s


# Set up the shared folder
RUN mkdir -p /srv/samba/share && \
    chmod 0777 /srv/samba/share

# Create Samba configuration file
RUN echo "[global]\n\
   workgroup = WORKGROUP\n\
   server string = Samba Server\n\
   security = user\n\
\n\
[share]\n\
   path = /srv/samba/share\n\
   writable = yes\n\
   guest ok = yes\n\
   guest only = no\n\
   valid users = myuser\n\
   create mask = 0777\n\
   directory mask = 0777\n\
" > /etc/samba/smb.conf

# Create the mount point for the shared folder
RUN mkdir -p /mnt/share

# Download and extract the archive
RUN wget https://projects.preferred.jp/mn-core/assets/mncore2_emuenv_20240412.tar.xz -O /srv/samba/share/mncore2_emuenv_20240412.tar.xz
RUN tar -xJvf /srv/samba/share/mncore2_emuenv_20240412.tar.xz -C /srv/samba/share

# Copy the locally created entrypoint.sh to the container
COPY entrypoint.sh /entrypoint.sh

# Grant execute permissions to the entrypoint script
RUN chmod +x /entrypoint.sh

# Execute the entrypoint script by default
CMD ["/entrypoint.sh"]
