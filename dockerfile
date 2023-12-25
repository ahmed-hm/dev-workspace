FROM mcr.microsoft.com/devcontainers/typescript-node:1-18-bookworm

ARG USERNAME
ARG AWS_REGION
ARG EKS_NAME
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG KUBECTL_VERSION
ARG HELM_VERSION
ARG PG_CLIENT_VERSION

USER ${USERNAME}

RUN curl -L "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/home/${USERNAME}/awscliv2.zip"
RUN unzip "/home/${USERNAME}/awscliv2.zip" -d "./home/${USERNAME}"
RUN sudo /home/${USERNAME}/aws/install

RUN curl -L "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/arm64/kubectl" -o "/home/${USERNAME}/kubectl"
RUN sudo install -o root -g root -m 0755 "/home/${USERNAME}/kubectl" "/usr/local/bin/kubectl"

RUN curl -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz" -o "/home/${USERNAME}/helm-v${HELM_VERSION}-linux-arm64.tar.gz"
RUN tar -zxvf "/home/${USERNAME}/helm-v${HELM_VERSION}-linux-arm64.tar.gz" -C "/home/${USERNAME}"
RUN ls -la "/home/${USERNAME}"
RUN sudo mv "/home/${USERNAME}/linux-arm64/helm" "/usr/local/bin/helm"

RUN aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
RUN aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
RUN aws configure set default.region ${AWS_REGION}

RUN aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_NAME}

RUN sudo apt update
RUN sudo apt -y install postgresql-client-${PG_CLIENT_VERSION}

RUN sudo apt -y install protobuf-compiler 

RUN bash -i -c "nvm install 18.17.1"
RUN bash -i -c "nvm alias default 18.17.1"
RUN bash -i -c "nvm use default"

RUN npm i -g @nestjs/cli@10.1.18
RUN npm i -g yalc

RUN git clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-/home/${USERNAME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
RUN sed -i "/^plugins=/c\plugins=(git zsh-autosuggestions sudo web-search copyfile copybuffer copypath dirhistory history jsontools)" /home/${USERNAME}/.zshrc

RUN git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" /home/${USERNAME}/zsh-syntax-highlighting
RUN echo "source /home/${USERNAME}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${ZDOTDIR:-$HOME}/.zshrc"

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history"  \
  && sudo mkdir "/commandhistory" \
  && sudo touch "/commandhistory/.zsh_history" \
  && sudo chown -R ${USERNAME} "/commandhistory" \
  && echo $SNIPPET >> "/home/${USERNAME}/.zshrc"

CMD [ "sleep infinity" ]