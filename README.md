# Docker-SMTA

### SMTA This is a securely configured mail relay with REST API.
Components:
 - [Postfix](http://postfix.org "Postfix")
 - [Amavis](http://amavis.org "Amavis")
 - [Postgrey](https://postgrey.schweikert.ch/ "Postgrey")
 - [ClamAV](https://www.clamav.net/ "ClamAV")
 - [Spamassassin](https://spamassassin.apache.org/ "Spamassassin")
 - [Razor](http://razor.sourceforge.net/ "Razor")
 - [API-SMTA](http://github.com/spanarek/api-smta)

Full documentation for allowed API-methods and parameters see in [Swagger UI](https://editor.swagger.io/) files by location in [api-smta/swagger](https://github.com/spanarek/api-smta/tree/master/swagger).

### Make image:
```
docker build -t smta .
```
### Run docker ephemeral:
```
docker run -d --name smta \
 -v postfix_conf:/etc/postfix \
 -v amavis_conf:/etc/amavisd \
 -p 25:25 -p 9443:9443 \
 --hostname=mta01.company.com smta
```
### Run with volumes(recommended):
```
docker run -d --name smta \
  -p 25:25 -p 9443:9443 \
  -v postfix_conf:/etc/postfix \
  -v amavis_conf:/etc/amavisd \
  -v smta_logs:/var/log \
  -v clamav:/var/lib/clamav \
  -v quarantine:/var/amavis/quarantine \
  -v local_mail:/var/mail \
  -v spool:/var/spool/postfix/ \
 --hostname=mta01.company.com smta 
```
