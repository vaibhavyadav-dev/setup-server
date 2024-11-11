FROM ubuntu
COPY customaction.sh .
RUN chmod +x setup.sh
ENTRYPOINT ["/setup.sh"]
