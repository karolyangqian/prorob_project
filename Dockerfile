FROM dustynv/ros:humble-ros-base-l4t-r32.7.1

# Hindari prompt interaktif saat instalasi package
ARG DEBIAN_FRONTEND=noninteractive

# Set working directory sesuai volume workspace kamu
WORKDIR /root/prorob_ws

# Otomatisasi Source ROS 2 dan Workspace ke dalam .bashrc
RUN echo "source /opt/ros/humble/install/setup.bash" >> /root/.bashrc \
    && echo "if [ -f /root/prorob_ws/install/setup.bash ]; then source /root/prorob_ws/install/setup.bash; fi" >> /root/.bashrc

# Buat script entrypoint kustom yang aman dari masalah newline
RUN printf '#!/bin/bash\n\
source /opt/ros/humble/install/setup.bash\n\
if [ -f /root/prorob_ws/install/setup.bash ]; then\n\
    source /root/prorob_ws/install/setup.bash\n\
fi\n\
exec "$@"\n' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Jalankan entrypoint kustom
ENTRYPOINT ["/entrypoint.sh"]

# Perintah default agar kontainer tetap hidup di background
CMD ["tail", "-f", "/dev/null"]