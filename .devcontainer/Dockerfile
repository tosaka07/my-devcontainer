FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG USERNAME
ARG WORK_DIR

USER root

ENV TZ=Asia/Tokyo \
  LANG=ja_JP.UTF-8 \
  LANGUAGE=ja_JP:ja \
  LC_ALL=ja_JP.UTF-8 \
  USER_HOME=/home/${USERNAME} \
  XDG_STATE_HOME=/home/${USERNAME}/.local/state \
  XDG_DATA_HOME=/home/${USERNAME}/.local/share \
  XDG_CONFIG_HOME=/home/${USERNAME}/.config \
  PATH=/home/vscode/.local/bin:${PATH}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  locales \
  less \
  git \
  procps \
  sudo \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  vim \
  curl \
  wget \
  ca-certificates \
  && apt-get clean && rm -rf /var/lib/apt/lists/*


# ディレクトリは所有者付きで作成
RUN install -d -o "${USERNAME}" -g "${USERNAME}" \
  "${WORK_DIR}" \
  "${XDG_STATE_HOME:-/home/${USERNAME}/.local/state}" \
  "${XDG_DATA_HOME:-/home/${USERNAME}/.local/share}" \
  "${XDG_CONFIG_HOME:-/home/${USERNAME}/.config}" \
  && mkdir -p /home/${USERNAME} /mnt/mise-data ${XDG_DATA_HOME}/atuin ${XDG_DATA_HOME}/sheldon ${XDG_CONFIG_HOME}/gh ${XDG_CONFIG_HOME}/gcloud /home/${USERNAME}/.claude \
  && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} /mnt/mise-data ${XDG_DATA_HOME}/atuin ${XDG_DATA_HOME}/sheldon ${XDG_CONFIG_HOME}/gh ${XDG_CONFIG_HOME}/gcloud /home/${USERNAME}/.claude

USER ${USERNAME}

# mise
RUN curl https://mise.run | sh

# sheldon
RUN curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
  | bash -s -- --repo rossmacarthur/sheldon --to ${USER_HOME}/.local/bin

# Firewall
COPY scripts/init-firewall.sh /usr/local/bin/

USER root

RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "${USERNAME} ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/${USERNAME}-firewall && \
  chmod 0440 /etc/sudoers.d/${USERNAME}-firewall
USER ${USERNAME}

WORKDIR ${WORK_DIR}
