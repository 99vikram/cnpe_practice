# Q13 (mock 1)
kubectl set env deployment/checkout-svc -n tracing \
  OTEL_RESOURCE_ATTRIBUTES=service.version=2.1,deployment.environment=production \
  OTEL_TRACES_SAMPLER=parentbased_traceidratio \
  OTEL_TRACES_SAMPLER_ARG=0.25
kubectl rollout status deployment/checkout-svc -n tracing
kubectl set env deployment/checkout-svc -n tracing --list

# Q13b (mock 2): find the collector first
kubectl get svc -n tracing
kubectl set env deployment/notification-svc -n tracing \
  OTEL_SERVICE_NAME=notification-svc \
  OTEL_EXPORTER_OTLP_ENDPOINT=http://jaeger-collector.tracing:4317 \
  OTEL_TRACES_EXPORTER=otlp
