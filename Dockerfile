FROM cm2network/steamcmd:root

ARG STEAMAPPBRANCH=public
ENV STEAMAPPID=380870
ENV STEAMAPPDIR="${HOMEDIR}/pz-dedicated"
ENV STEAMAPPBRANCH=$STEAMAPPBRANCH

# สร้าง Directory และเปลี่ยนเจ้าของให้ถูกต้องก่อนสลับ User
RUN mkdir -p "${STEAMAPPDIR}" "${HOMEDIR}/Zomboid" \
    && chown -R "${USER}:${USER}" "${HOMEDIR}"

# สลับไปใช้ User steam เพื่อความปลอดภัยและลดปัญหา Config Path
USER ${USER}

# รัน SteamCMD โดยใช้ User steam
RUN bash "${STEAMCMDDIR}/steamcmd.sh" \
    +force_install_dir "${STEAMAPPDIR}" \
    +login anonymous \
    +app_update "${STEAMAPPID}" -beta "${STEAMAPPBRANCH}" validate \
    +quit

# สลับกลับมาเป็น root เพื่อก๊อปปี้ไฟล์และ Set Permission (ถ้าจำเป็น)
USER root
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh \
    && chown "${USER}:${USER}" /entry.sh

# สุดท้ายให้รันด้วย User steam เสมอ
USER ${USER}
WORKDIR ${HOMEDIR}
ENTRYPOINT ["/entry.sh"]
