# Konfiguracja Self-Hosted Agent dla Azure DevOps

## Wymagania wstępne
- Skonfigurowany projekt w Azure DevOps
- Wdrożona maszyna wirtualna za pomocą Terraform (katalog `infra/`)
- Personal Access Token (PAT) z uprawnieniami do Agent Pools

## Kroki konfiguracji

### 1. Przygotowanie Personal Access Token (PAT)
1. Przejdź do Azure DevOps -> User Settings -> Personal Access Tokens
2. Utwórz nowy token z uprawnieniami:
   - Agent Pools (Read & Manage)
   - Deployment Groups (Read & Manage)

### 2. Konfiguracja agenta na maszynie wirtualnej

bash

## Połącz się z maszyną wirtualną

```bash
ssh azureuser@<vm-ip>
```

## Utwórz katalog roboczy


```bash
mkdir myagent && cd myagent
```


##Pobierz agenta

```bash
wget https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-linux-x64-3.234.0.tar.gz
tar zxvf vsts-agent-linux-x64-3.234.0.tar.gz
```
Skonfiguruj agenta

```bash
./config.sh

## wygeneruj PAT - to nie najszczęsliwa opcja, ale działa na nasze potrzeby, lepszy byłby Key Vault

```bash
az devops service-endpoint PAT create --organization https://dev.azure.com/koto --name "ADO-PAT" --personal-access-token <PAT> --? :o
```

Zainstaluj usługę
sudo ./svc.sh install
Uruchom usługę
sudo ./svc.sh start
bash
Sprawdź status usługi
sudo ./svc.sh status
Sprawdź logi systemowe
journalctl -u vsts.agent
bash
Zatrzymanie agenta
sudo ./svc.sh stop
Restart agenta
sudo ./svc.sh restart
Odinstalowanie agenta
sudo ./svc.sh uninstall
You can create this file using one of these methods:
