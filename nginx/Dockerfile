FROM nginx:latest
COPY reverse-proxy.conf /etc/nginx/conf.d/reverse-proxy.conf
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]