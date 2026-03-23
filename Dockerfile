FROM cm2network/steamcmd:root

ARG STEAMAPPBRANCH=public
ENV STEAMAPPID=380870
ENV STEAMAPPDIR="${HOMEDIR}/pz-dedicated"
ENV STEAMAPPBRANCH=$STEAMAPPBRANCH

RUN mkdir -p "${STEAMAPPDIR}" "${HOMEDIR}/Zomboid" \
    && chown -R "${USER}:${USER}" "${HOMEDIR}"

USER ${USER}

RUN bash "${STEAMCMDDIR}/steamcmd.sh" \
    +force_install_dir "${STEAMAPPDIR}" \
    +login anonymous \
    +app_update "${STEAMAPPID}" -beta "${STEAMAPPBRANCH}" validate \
    +quit

USER root
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh \
    && chown "${USER}:${USER}" /entry.sh

USER ${USER}
WORKDIR ${HOMEDIR}
ENTRYPOINT ["/entry.sh"]
