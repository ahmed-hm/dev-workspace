FROM mcr.microsoft.com/devcontainers/typescript-node:1-18-bookworm

ARG USER_NAME
ARG KUBECTL_VERSION
ARG HELM_VERSION

USER ${USER_NAME}

RUN curl -L "https://dl.k8s.io/release/v{KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o "/home/${USER_NAME}/kubectl"
RUN sudo install -o root -g root -m 0755 "/home/${USER_NAME}/kubectl" "/usr/local/bin/kubectl"

RUN curl -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o "/home/${USER_NAME}/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN tar -zxvf "/home/${USER_NAME}/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -C "/home/${USER_NAME}"
RUN ls -la "/home/${USER_NAME}"
RUN sudo mv "/home/${USER_NAME}/linux-amd64/helm" "/usr/local/bin/helm"

RUN sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN sudo unzip awscliv2.zip
RUN sudo ./aws/install

RUN bash -i -c "nvm install 18.17.1"
RUN bash -i -c "nvm alias default 18.17.1"
RUN bash -i -c "nvm use default"

RUN npm i -g @nestjs/cli@10.1.18
RUN npm i -g yalc

RUN git clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-/home/${USER_NAME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
RUN sed -i "/^plugins=/c\plugins=(git zsh-autosuggestions sudo web-search copyfile copybuffer copypath dirhistory history jsontools)" /home/${USER_NAME}/.zshrc

RUN git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" /home/${USER_NAME}/zsh-syntax-highlighting
RUN echo "source /home/${USER_NAME}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${ZDOTDIR:-$HOME}/.zshrc"

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history"  \
  && sudo mkdir "/commandhistory" \
  && sudo touch "/commandhistory/.zsh_history" \
  && sudo chown -R ${USER_NAME} "/commandhistory" \
  && echo $SNIPPET >> "/home/${USER_NAME}/.zshrc"

CMD [ "sleep infinity" ]