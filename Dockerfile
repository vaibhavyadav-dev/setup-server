FROM ubuntu
COPY customaction.sh .
RUN chmod +x customaction.sh
ENTRYPOINT ["/customaction.sh"]
