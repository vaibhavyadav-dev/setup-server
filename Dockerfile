FROM ubuntu
COPY setup.sh .
RUN chmod +x setup.sh
ENTRYPOINT ["/setup.sh"]
