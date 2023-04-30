{{- define "app.env" -}}
- name: DATABASE_NAME
  value: "{{ .Values.postgress.dbName }}"
- name: DATABASE_URL
  value: "{{ .Values.appName }}-postgres"
- name: DATABASE_PORT
  value: "5432"
- name: DATABASE_USER
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.postgress.secrets.user.name }}"
      key: "{{ .Values.postgress.secrets.user.key }}"
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.postgress.secrets.password.name }}"
      key: "{{ .Values.postgress.secrets.password.key }}"
- name: RAILS_APP
  value: "production"
- name: RAILS_ENV
  value: "production"
- name: REDIS_URL
  value: "{{ .Values.appName }}-redis"
- name: REDIS_PORT
  value: "6379"
- name: SECRET_KEY_BASE
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.app.secrets.secretKeyBase.name }}"
      key: "{{ .Values.app.secrets.secretKeyBase.key }}"
{{- end }}
