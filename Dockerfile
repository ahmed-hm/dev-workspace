FROM mcr.microsoft.com/devcontainers/typescript-node:1-18-bookworm

USER node

RUN bash -i -c "nvm install 18.17.1"
RUN bash -i -c "nvm alias default 18.17.1"
RUN bash -i -c "nvm use default"

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions sudo web-search copyfile copybuffer copypath dirhistory history jsontools)' ~/.zshrc

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting
RUN echo "source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

CMD [ "sleep infinity" ]