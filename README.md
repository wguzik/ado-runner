# Konfiguracja Self-Hosted Agent dla Azure DevOps

Są sytuacje, kiedy agenty Azure DevOps nie są dostępne, brakuje im oprogramowania lub nie możemy z nich korzystać (np. ograniczenia sieciowe, bezpieczeństwa itd.).

W takich przypadkach można skonfigurować Self-Hosted Agent na maszynie wirtualnej.
W praktyce oznacza to zbudowanie maszyny wirtualnej z odpowiednim oprogramowaniem oraz skonfigurowanie agenta Azure DevOps.
Po takiej operacji maszyna wirtualna będzie mogła być używana do uruchamiania Pipelines w Azure DevOps.

## Wymagania wstępne

- Skonfigurowany projekt w Azure DevOps

## Przygotowanie infrastruktury

Zrób klon repozytorium:

```bash
git clone https://github.com/wguzik/ado-runner.git
```

Wejdź do katalogu z projektem i infrastrukturą:

```bash
cd ado-runner/infra/
```

Przygotuj plik z zmiennymi:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Wprowadź wartości dla zmiennych w pliku `terraform.tfvars`

Wystarczy wartość `owner`, inicjały wystarczą.

```bash
code .
```

Zapisz zmiany i wyjdź.

Wdróż infrastrukturę:

```bash
terraform validate
terraform init
terraform apply
```

Zapisz zewnętrzny adres IP maszyny wirtualnej oraz znajdź hasło do maszyny wirtualnej w Key Vault.

## Konfiguracja agenta

### Detale agentów

Przejdź do Azure DevOps -> Project Settings -> Agent pools > Default (zakładka `Agent`) > "New agent" (zakładka `Linux`)

żeby podejrzeć co jest potrzebne do konfiguracji agenta. 

### 1. Przygotowanie Personal Access Token (PAT)
1. Przejdź do Azure DevOps -> User Settings -> Personal Access Tokens
2. Utwórz nowy token z uprawnieniami:
   - Agent Pools (Read & Manage)
   - Deployment Groups (Read & Manage)

3. Zapisz na boku wartość tokenu, bo ponieważ jeżeli zamkniesz okno, nie będzie można go ponownie wyświetlić.

<video src='./media/setup-pat.mp4' width=360 controls></video>


### 2. Konfiguracja agenta na maszynie wirtualnej


## Połącz się z maszyną wirtualną

Hasło znajdziesz w Key Vault

```bash
ssh adminuser@<vm-ip>
```

## Utwórz katalog roboczy


```bash
mkdir myagent && cd myagent
```


##Pobierz agenta

```bash
wget https://vstsagentpackage.azureedge.net/agent/3.248.0/vsts-agent-linux-x64-3.248.0.tar.gz
tar zxvf vsts-agent-linux-x64-3.248.0.tar.gz
```

## zainstaluj aplikacje

```
sudo ./bin/installdependencies.sh


Skonfiguruj agenta

```bash
./config.sh

Enter (Y/N) Accept the Team Explorer Everywhere license agreement now? (press enter for N) >
Y

Enter server URL: https://dev.azure.com/<nazwa organizacji>
dev.azure.com/wojciechguzik0366/

Enter authentication type (press enter for PAT) > [enter]

Enter agent pool (press enter for default) > [enter]

Enter agent name (press enter for ado-wg-vm) > [enter]

Enter work folder (press enter for _work) > [enter]


## wygeneruj PAT - to nie najszczęsliwa opcja, ale działa na nasze potrzeby, lepszy byłby Key Vault


Zainstaluj usługę
sudo ./svc.sh install
Uruchom usługę
sudo ./svc.sh start
bash
Sprawdź status usługi
sudo ./svc.sh status

Nawiguj do Pipelines i zonavz, że musisz przyznać uprawnienia.

Przyznaj permin i czekaj.

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
